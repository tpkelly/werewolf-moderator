//
//  BallotManager.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 15/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "BallotManager.h"
#import "Vote.h"
#import "GameState.h"
#import "Player.h"
#import "Role.h"
#import "AttackUtility.h"
#import "Ballot.h"


@interface BallotManager ()

@property (nonatomic, strong) GameState *state;

@end

@implementation BallotManager

-(instancetype)initWithState:(GameState *)state
{
    self = [super init];
    if (self)
    {
        self.state = state;
    }
    return self;
}

-(NSArray*)firstRoundResults:(Ballot *)ballot
{
    NSArray *votes = [self votesWithSeducerVotes:ballot.votes];
    
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
    
    if (ballot.inquisitionTarget.role.isMystic && ![playersOnBallot containsObject:ballot.inquisitionTarget])
    {
        playersOnBallot = [playersOnBallot arrayByAddingObject:ballot.inquisitionTarget];
    }
    
    return playersOnBallot;
}

-(Player *)secondRoundResults:(Ballot *)ballot
{
    NSArray *votes = [self votesWithSeducerVotes:ballot.votes];
    
    // Reset Jester burning flag
    BOOL jesterBurned = self.state.jesterBurnedLastNight;
    self.state.jesterBurnedLastNight = NO;
    
    if (jesterBurned)
    {
        return nil;
    }

    if (ballot.inquisitionTarget.role.isMystic || ballot.inquisitionTarget.role.isShadow)
    {
        // Set all other votes to 0 (may result in an empty list if ballot.inquisitionTarget got no votes)
        votes = [votes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Vote *vote, NSDictionary *bindings) {
            return vote.player == ballot.inquisitionTarget;
        }]];
    }
    
    NSArray *mostVotedPlayers = [self mostVotedPlayers:votes];
    
    // Village was undecided
    if (mostVotedPlayers.count != 1)
    {
        return nil;
    }
    
    Player *mostVotedPlayer = [mostVotedPlayers firstObject];
   
    Player *burnedPlayer = [AttackUtility killPlayer:mostVotedPlayer reason:BurnedAtStake state:_state];
    
    if (burnedPlayer.role.roleType == WolfPup)
    {
        self.state.wolvesAttackTwice = YES;
    }
    else if (burnedPlayer.role.roleType == Jester)
    {
        self.state.jesterBurnedLastNight = YES;
        self.state.winningFactions = [self.state.winningFactions arrayByAddingObject:@(JesterFaction)];
    }
    
    return burnedPlayer;
}

-(NSArray*)votesWithSeducerVotes:(NSArray*)votes
{
    votes = [votes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"voteCount > 0"]];

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
