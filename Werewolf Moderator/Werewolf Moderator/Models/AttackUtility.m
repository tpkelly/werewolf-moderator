//
//  AttackUtility.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 17/05/2015.
//  Copyright (c) 2015 TKGames. All rights reserved.
//

#import "AttackUtility.h"
#import "GameState.h"
#import "Player.h"
#import "Role.h"

@implementation AttackUtility

+(Player*)killPlayer:(Player*)player reason:(KillReason)reason state:(GameState*)state
{
    if (player == nil) {
        return nil;
    }
   
    // Kill romeo with Juliet
    if (player.role.roleType == Juliet && reason != RomeoJulietSuicide)
    {
        [self killPlayer:state.romeoPlayer reason:RomeoJulietSuicide state:state];
    }
    else if (player == state.romeoPlayer && reason != RomeoJulietSuicide)
    {
        Player *juliet = [state playerWithRole:Juliet inPlayerSet:state.playersAlive];
        [self killPlayer:juliet reason:RomeoJulietSuicide state:state];
    }
    
    Player *guardianAngel = [state playerWithRole:GuardianAngel inPlayerSet:state.playersAlive];
    if (guardianAngel && state.guardedPlayer == player)
    {
        return [self killPlayer:guardianAngel reason:AngelSuicide state:state];
    }
    
    // Kill now
    if (reason == BurnedAtStake || reason == ItIsMorning)
    {
        player.isCursed = NO;
        player.alive = NO;
        [self checkLiftCurses:player state:state];
        [self checkInquisitorDied:player state:state];
    }
    // Kill later
    else
    {
        NSMutableArray *destinedToDie = [state.destinedToDie mutableCopy];
        [destinedToDie addObject:player];
        state.destinedToDie = destinedToDie;
    }
    
    return player;
}

+(void)checkInquisitorDied:(Player*)player state:(GameState*)state
{
    if (player.role.roleType != Inquisitor)
        return;
    
    if (![state roleIsAlive:Templar])
        return;
    
    NSArray *aliveMystics = [state.playersAlive filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"role.isMystic == YES"]];
    
    if (aliveMystics.count > 0)
        state.countdownClock = @(aliveMystics.count);
}

+(void)checkLiftCurses:(Player*)player state:(GameState*)state
{
    if (player.role.roleType != Hag)
        return;
    
    // Killing the hag lifts all curses
    for (Player *player in state.playersAlive)
    {
        player.isCursed = NO;
    }
}

@end
