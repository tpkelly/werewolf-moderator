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
    votes = [self votesWithSeducerVotes:votes];
    
    NSArray *mostVotedPlayers = [self mostVotedPlayers:votes];
    
    NSPredicate *allOtherVotedPredicate = [NSPredicate predicateWithBlock:^BOOL(Vote *evaluatedObject, NSDictionary *bindings) {
        return ![mostVotedPlayers containsObject:evaluatedObject.player];
    }];
    NSArray *allOtherVoted = [votes filteredArrayUsingPredicate:allOtherVotedPredicate];
    
    NSArray *secondMostVotedPlayers = [self mostVotedPlayers:allOtherVoted];
    
    NSArray *playersOnBallot = [mostVotedPlayers arrayByAddingObjectsFromArray:secondMostVotedPlayers];

    Player *guardianAngel = [self.state playerWithRole:GuardianAngel inPlayerSet:self.state.playersAlive];
    if (guardianAngel && ![playersOnBallot containsObject:guardianAngel] && [playersOnBallot containsObject:self.state.guardedPlayer])
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
    votes = [self votesWithSeducerVotes:votes];
    
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
    Player *destinedPlayer;
    
    if (playerToBurn == self.state.guardedPlayer)
    {
        Player *guardianAngel = [self.state playerWithRole:GuardianAngel inPlayerSet:self.state.playersAlive];
        playerToBurn = (guardianAngel) ? guardianAngel : playerToBurn;
    }
    if (playerToBurn == self.state.romeoPlayer)
    {
        Player *juliet = [self.state playerWithRole:Juliet inPlayerSet:self.state.playersAlive];
        
        // The Juliet role may no longer be in the game, if Juliet was turned into a Minion!
        if (juliet)
        {
            self.state.destinedToDie = [self.state.destinedToDie arrayByAddingObject:juliet];
        }
    }
    
    // Cancel next ballot if jester is burned
    if (playerToBurn.role.roleType == Jester)
    {
        self.state.jesterBurnedLastNight = YES;
        self.state.winningFactions = [self.state.winningFactions arrayByAddingObject:@(JesterFaction)];
    }
    else if (playerToBurn.role.roleType == Juliet)
    {
        destinedPlayer = self.state.romeoPlayer;

        if (self.state.romeoPlayer == self.state.guardedPlayer)
        {
            Player *guardianAngel = [self.state playerWithRole:GuardianAngel inPlayerSet:self.state.playersAlive];
            destinedPlayer = (guardianAngel) ? guardianAngel : destinedPlayer;
        }
    }
    else if (playerToBurn.role.roleType == WolfPup)
    {
        self.state.wolvesAttackTwice = YES;
    }
        
    // No hope left, kill the player!
    playerToBurn.alive = NO;
    
    if (destinedPlayer)
    {
        self.state.destinedToDie = [self.state.destinedToDie arrayByAddingObject:destinedPlayer];
    }
    
    return playerToBurn;
}

-(NSArray*)votesWithSeducerVotes:(NSArray*)votes
{
    NSMutableArray *mutableVotes = [votes mutableCopy];
    
    NSUInteger seducerIndex = [mutableVotes indexOfObjectPassingTest:^BOOL(Vote *vote, NSUInteger idx, BOOL *stop) {
        return vote.player.role.roleType == Seducer;
    }];
    
    if (seducerIndex == NSNotFound)
        return votes;
    
    Vote *seducerVote = [mutableVotes objectAtIndex:seducerIndex];
    //Halved, rounded up
    Vote *adjustedSeducerVote = [Vote forPlayer:seducerVote.player voteCount:(seducerVote.voteCount+1)/2];
    [mutableVotes replaceObjectAtIndex:seducerIndex withObject:adjustedSeducerVote];
    
    // Return as immutable
    return [mutableVotes copy];
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
