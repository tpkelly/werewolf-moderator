//
//  Ballot.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 15/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "Ballot.h"
#import "Vote.h"
#import "GameState.h"
#import "Player.h"
#import "Role.h"

@interface Ballot ()

@property (nonatomic, strong) GameState *state;

@end

@implementation Ballot

-(instancetype)initWithState:(GameState *)state
{
    self = [super init];
    if (self)
    {
        self.state = state;
    }
    return self;
}

-(NSArray*)firstRoundResults:(NSArray *)votes
{
    NSArray *mostVotedPlayers = [self mostVotedPlayers:votes];
    
    NSPredicate *allOtherVotedPredicate = [NSPredicate predicateWithBlock:^BOOL(Vote *evaluatedObject, NSDictionary *bindings) {
        return ![mostVotedPlayers containsObject:evaluatedObject.player];
    }];
    NSArray *allOtherVoted = [votes filteredArrayUsingPredicate:allOtherVotedPredicate];
    
    NSArray *secondMostVotedPlayers = [self mostVotedPlayers:allOtherVoted];
    
    NSArray *playersOnBallot = [mostVotedPlayers arrayByAddingObjectsFromArray:secondMostVotedPlayers];

    Player *guardianAngel = [self.state playerWithRole:GuardianAngel inPlayerSet:self.state.playersAlive];
    if (guardianAngel && ![playersOnBallot containsObject:guardianAngel])
    {
        NSUInteger guardedIndex = [playersOnBallot indexOfObject:self.state.guardedPlayer];
        
        //Get mutable copy to do mutable operations
        NSMutableArray *mutableBallot = [playersOnBallot mutableCopy];
        [mutableBallot replaceObjectAtIndex:guardedIndex withObject:guardianAngel];
        
        //Make Immutable again
        playersOnBallot = [mutableBallot copy];
    }
    
    return playersOnBallot;
}

-(Player *)secondRoundResults:(NSArray *)votes
{
    // Reset Jester burning flag
    BOOL jesterBurned = self.state.jesterBurnedLastNight;
    self.state.jesterBurnedLastNight = NO;
    
    if (jesterBurned)
    {
        return nil;
    }
    
    NSArray *mostVotedPlayers = [self mostVotedPlayers:votes];
    
    // Village was undecided
    if (mostVotedPlayers.count != 1)
    {
        return nil;
    }
    
    Player *playerToBurn = [mostVotedPlayers firstObject];
    
    // Cancel next ballot if jester is burned
    if (playerToBurn.role.roleType == Jester)
    {
        self.state.jesterBurnedLastNight = YES;
    }
    else if (playerToBurn.role.roleType == Juliet)
    {
        self.state.destinedToDie = [self.state.destinedToDie arrayByAddingObject:self.state.romeoPlayer];
    }
    else if (playerToBurn == self.state.romeoPlayer)
    {
        Player *juliet = [self.state playerWithRole:Juliet inPlayerSet:self.state.playersAlive];
        
        // The Juliet role may no longer be in the game, if Juliet was turned into a Minion!
        if (juliet)
        {
            self.state.destinedToDie = [self.state.destinedToDie arrayByAddingObject:juliet];
        }
    }
    else if (playerToBurn == self.state.guardedPlayer)
    {
        Player *guardianAngel = [self.state playerWithRole:GuardianAngel inPlayerSet:self.state.playersAlive];
        playerToBurn = (guardianAngel) ? guardianAngel : playerToBurn;
    }
    
    return playerToBurn;
}

-(NSArray*)mostVotedPlayers:(NSArray*)votes
{
    NSInteger maxScore = [[votes valueForKeyPath:@"@max.voteCount"] integerValue];
    NSPredicate *mostVotedPredicate = [NSPredicate predicateWithBlock:^BOOL(Vote *evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.voteCount == maxScore;
    }];
    
    NSArray *mostVotedPlayers = [votes filteredArrayUsingPredicate:mostVotedPredicate];
    return [mostVotedPlayers valueForKey:@"player"];
}

@end
