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
#import "MorningNews.h"

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
    player.temporaryProtection = YES;
}

-(void)healerSavesPlayer:(Player *)player
{
    if (!_state.healerHasPowers)
    {
        return;
    }
    
    NSMutableArray *destinedToDie = [_state.destinedToDie mutableCopy];
    
    // "Once per game, unless dying..." - Healer cannot save if they are about to die
    Player *healerDestinedToDie = [_state playerWithRole:Healer inPlayerSet:destinedToDie];
    if (healerDestinedToDie)
    {
        return;
    }
    
    //Let him be saaaved!
    [destinedToDie removeObject:player];
    
    _state.destinedToDie = destinedToDie;
    _state.healerHasPowers = NO;
}

#pragma mark - Nightly attacks

-(BOOL)wolfAttackPlayer:(Player *)player
{
    return YES;
}

-(BOOL)vampireAttackPlayer:(Player *)player
{
    // Protected from vampire attacks
    if (player.temporaryProtection || player.permanentProtection || player.role.isMystic)
    {
        return NO;
    }
    
    // Critical mission failure - Kill the vampire/igor off
    if (player.role.roleType == VampireHunter || player.role.faction == WolvesFaction)
    {
        //Kill igor if they are in play, or the vampire if not
        Player *playerToKill = [_state playerWithRole:Igor inPlayerSet:_state.playersAlive];
        if (!playerToKill)
        {
            playerToKill = [_state playerWithRole:Vampire inPlayerSet:_state.playersAlive];
        }
        _state.destinedToDie = [_state.destinedToDie arrayByAddingObject:playerToKill];
        return NO;
    }
    
    // Just as planned...
    player.role = [[Role alloc] initWithRole:Minion];
    return YES;
}

#pragma mark - First night actions

-(void)julietPicksRomeo:(Player *)player
{
    _state.romeoPlayer = player;
    player.permanentProtection = YES;
}

#pragma mark - It is morning

-(MorningNews *)transitionToMorning
{
    MorningNews *news = [MorningNews new];
    news.diedLastNight = _state.destinedToDie;
    
    NSMutableArray *playersAlive = [_state.playersAlive mutableCopy];
    [playersAlive removeObjectsInArray:_state.destinedToDie];
    
    _state.playersAlive = playersAlive;
    _state.playersDead = [_state.playersDead arrayByAddingObjectsFromArray:_state.destinedToDie];
    _state.destinedToDie = @[];
    
    return news;
}

@end
