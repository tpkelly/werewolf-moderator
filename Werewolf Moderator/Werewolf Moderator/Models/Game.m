//
//  Game.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 14/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "Game.h"
#import "Player.h"
#import "Role.h"
#import "GameState.h"

@implementation Game

-(instancetype)initWithState:(GameState *)state
{
    self = [super init];
    if (self)
    {
        _state = state;
    }
    return self;
}

#pragma mark - Mystic Abilities

-(BOOL)clairvoyantChecksPlayer:(Player *)player
{
    BOOL checkedPlayerWasCorrupt = player.role.isCorrupt;
    
    if (checkedPlayerWasCorrupt && [_state roleIsAlive:Innkeeper])
    {
        _state.newsFromTheInn = FoundCorrupt;
    }
    else if (!checkedPlayerWasCorrupt && [_state roleIsAlive:Bard])
    {
        _state.newsFromTheInn = FoundNonCorrupt;
    }
    else
    {
        _state.newsFromTheInn = NoNews;
    }
    
    return checkedPlayerWasCorrupt;
}

-(BOOL)mediumChecksPlayer:(Player *)player
{
    return player.role.isCorrupt;
}

-(BOOL)wizardChecksPlayer:(Player *)player
{
    return player.role.isMystic;
}

-(void)witchProtectPlayer:(Player *)player
{
    
}

-(void)healerSavesPlayer:(Player *)player
{
    
}

#pragma mark - Nightly attacks

-(void)wolfAttackPlayer:(Player *)player
{
    
}

-(void)vampireAttackPlayer:(Player *)player
{
    
}

@end
