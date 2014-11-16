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

-(void)firstRoundResults:(NSArray *)votes
{
    
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
    
    int maxScore = [[votes valueForKeyPath:@"@max.voteCount"] integerValue];
    NSPredicate *mostVotedPredicate = [NSPredicate predicateWithBlock:^BOOL(Vote *evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.voteCount == maxScore;
    }];
    
    NSArray *mostVotedPlayers = [votes filteredArrayUsingPredicate:mostVotedPredicate];
    
    Vote *mostVoted = [mostVotedPlayers firstObject];
    Player *playerToBurn = mostVoted.player;
    
    // Cancel next ballot if jester is burned
    if (playerToBurn.role.roleType == Jester)
    {
        self.state.jesterBurnedLastNight = YES;
    }
    
    return playerToBurn;
}

@end
