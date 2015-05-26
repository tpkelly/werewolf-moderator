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
#import "MinionRole.h"
#import "RomeoRole.h"
#import "GuardedRole.h"
#import "GameState.h"
#import "MorningNews.h"
#import "AttackUtility.h"

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

#pragma mark - Utility Methods

-(BOOL)hagCheck:(Player*)potentialHag forMystic:(RoleType)mysticRole
{
    Player *mystic = [_state playerWithRole:mysticRole inPlayerSet:_state.playersAlive];
    
    if (mystic.isCursed)
    {
        return NO;
    }
    
    if (potentialHag.role.roleType == Hag)
    {
        Player *mystic = [_state playerWithRole:mysticRole inPlayerSet:_state.playersAlive];
        mystic.isCursed = YES;
    }
    
    return YES;
}

#pragma mark - Mystic Abilities

-(BOOL)clairvoyantChecksPlayer:(Player *)player
{
    BOOL checkedPlayerWasCorrupt = player.role.isCorrupt || player.isCursed;
    
    _state.newsFromTheInn = (checkedPlayerWasCorrupt) ? FoundCorrupt : FoundNonCorrupt;
    
    BOOL checkSucceeds = [self hagCheck:player forMystic:Clairvoyant];
    
    return checkSucceeds && checkedPlayerWasCorrupt;
}

-(BOOL)mediumChecksPlayer:(Player *)player
{
    return player.role.isCorrupt;
}

-(BOOL)wizardChecksPlayer:(Player *)player
{
    BOOL checkSucceeds = [self hagCheck:player forMystic:Wizard];
    return checkSucceeds && player.role.isMystic;
}

-(BOOL)witchProtectPlayer:(Player *)player
{
    BOOL protectionSuceeds = [self hagCheck:player forMystic:Witch];
    player.temporaryProtection = protectionSuceeds;
    return protectionSuceeds && player.isCursed;
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
    
    BOOL healSucceeds = [self hagCheck:player forMystic:Healer];
    
    if (!healSucceeds)
    {
        return;
    }

    //Let him be saaaved!
    [destinedToDie removeObject:player];
    
    _state.destinedToDie = destinedToDie;
    _state.healerHasPowers = NO;
}

#pragma mark - Nightly attacks

-(AttackResult)wolfAttackPlayer:(Player *)player
{
    if (player.role.roleType == Defector)
    {
        return TargetInformed;
    }
    
    // Madman blocks attacks
    if (_state.madmanMauledLastNight)
    {
        return TargetImmune;
    }
    
    // Protected from shadow attacks
    if (player.temporaryProtection || player.permanentProtection)
    {
        return TargetImmune;
    }
    
    [AttackUtility killPlayer:player reason:EatenByWolves state:_state];
    
    return Success;
}

-(AttackResult)vampireAttackPlayer:(Player *)player
{
    // Protected from vampire attacks
    if (player.temporaryProtection || player.permanentProtection || player.role.isMystic)
    {
        return TargetImmune;
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
        
        [AttackUtility killPlayer:playerToKill reason:VampireAttackGoneWrong state:_state];
        
        if (player.role.roleType == VampireHunter)
        {
            return TargetInformed;
        }
        else
        {
            return TargetImmune;
        }
    }
    
    // Just as planned...
    player.role = [[MinionRole alloc] initWithPreviousRole:player.role];
    return Success;
}

#pragma mark - First night actions

-(void)julietPicksRomeo:(Player *)player
{
    _state.romeoPlayer = player;
    player.role = [[RomeoRole alloc] initWithPreviousRole:player.role];
    player.permanentProtection = YES;
}

-(void)angelPicksGuarded:(Player *)player
{
    _state.guardedPlayer = player;
    player.role = [[GuardedRole alloc] initWithPreviousRole:player.role];
}

#pragma mark - It is morning

-(MorningNews *)transitionToMorning
{
    if (self.state.countdownClock)
    {
        self.state.countdownClock = @([self.state.countdownClock intValue] - 1);
    }
    
    Player *madmanDestinedToDie = [_state playerWithRole:Madman inPlayerSet:_state.destinedToDie];
    if (madmanDestinedToDie)
    {
        _state.winningFactions = [_state.winningFactions arrayByAddingObject:@(MadmanFaction)];
    }
    _state.madmanMauledLastNight = (madmanDestinedToDie != nil);
    
    _state.wolvesAttackTwice = NO;
    _state.isFirstNight = NO;
    
    MorningNews *news = [MorningNews new];
    news.diedLastNight = _state.destinedToDie;

    //Kill them all!
    for (Player *player in _state.destinedToDie)
    {
        [AttackUtility killPlayer:player reason:ItIsMorning state:_state];
    }
    _state.destinedToDie = @[];
    
    for (Player *player in _state.playersAlive)
    {
        player.temporaryProtection = NO;
    }
    
    // Find news from the inn
    news.news = _state.newsFromTheInn;
    _state.newsFromTheInn = NoNews;
    
    //We need the bard or innkeeper alive to hear about the news
    if ((news.news == FoundCorrupt && ![_state roleIsAlive:Innkeeper])
        || (news.news == FoundNonCorrupt && ![_state roleIsAlive:Bard]))
    {
        news.news = NoNews;
    }
    
    return news;
}

-(NSArray*)playersWithFactions
{
    NSPredicate *factionless = [NSPredicate predicateWithBlock:^BOOL(Player *player, NSDictionary *bindings) {
        return player.role.faction != Factionless;
    }];
    return [_state.playersAlive filteredArrayUsingPredicate:factionless];
}

-(BOOL)gameIsOver
{
    if ([_state.countdownClock isEqualToNumber:@0])
        return YES;
    
    NSArray *factionsInPlay = [[self playersWithFactions] valueForKeyPath:@"role.faction"];
    NSSet *factionSet = [NSSet setWithArray:factionsInPlay];
    
    //Wolf win
    if ([factionSet isEqualToSet:[NSSet setWithArray:@[@(WolvesFaction)]]])
        return YES;
    
    //Vampire win
    if ([factionSet isEqualToSet:[NSSet setWithArray:@[@(VampireFaction)]]])
        return YES;

    //Lovers win
    if (_state.playersAlive.count == 2)
    {
        if (([_state roleIsAlive:Juliet] && [_state.romeoPlayer alive])
            || ([_state roleIsAlive:GuardianAngel] && [_state.guardedPlayer alive]))
        {
            return YES;
        }
    }
    
    //Village wins if no shadows in play
    return ![self shadowsInPlay];
}

-(BOOL)shadowsInPlay
{
    NSPredicate *shadowFilter = [NSPredicate predicateWithBlock:^BOOL(Player *player, NSDictionary *bindings) {
        return player.role.isShadow || player.isCursed;
    }];
    NSArray *shadowsInPlay = [[self playersWithFactions] filteredArrayUsingPredicate:shadowFilter];
    
    return shadowsInPlay.count > 0;
}

-(NSSet*)factionsWhichWon
{
    if (![self gameIsOver])
    {
        return [NSSet set];
    }
    
    //Include dead madman/jester
    NSMutableArray *winningFactions = [_state.winningFactions mutableCopy];
    
    if ([_state.countdownClock isEqualToNumber:@0])
    {
        return [NSSet setWithArray:winningFactions];
    }
   
    //Include village if no shadows in play (and not already included)
    if (![self shadowsInPlay])
    {
        [winningFactions addObject:@(VillageFaction)];
    }
    else
    {
        NSArray *aliveFactions = [[self playersWithFactions] valueForKeyPath:@"role.faction"];
        [winningFactions addObjectsFromArray:aliveFactions];
    }
    
    //Include lovers
    if (([_state roleIsAlive:Juliet] && [_state.romeoPlayer alive])
        || ([_state roleIsAlive:GuardianAngel] && [_state.guardedPlayer alive]))
    {
        [winningFactions addObject:@(LoverFaction)];
    }
    
    //Remove duplicates and ignore ordering
    return [NSSet setWithArray:winningFactions];
}

@end
