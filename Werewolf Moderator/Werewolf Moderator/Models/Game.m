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
    
    _state.newsFromTheInn = (checkedPlayerWasCorrupt) ? FoundCorrupt : FoundNonCorrupt;

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
    // Madman blocks attacks
    if (_state.madmanMauledLastNight)
    {
        return NO;
    }
    
    // Protected from shadow attacks
    if (player.temporaryProtection || player.permanentProtection)
    {
        return NO;
    }
    
    NSMutableArray *destinedToDie = [_state.destinedToDie mutableCopy];
    
    // Kill romeo with juliet - Romeo is immune to shadow attacks, so this only happens one way around.
    if (player.role.roleType == Juliet)
    {
        [destinedToDie addObject:_state.romeoPlayer];
    }
    // Guardian angel takes Guarded's place, if possible.
    else if (player == _state.guardedPlayer)
    {
        Player *guardianAngel = [_state playerWithRole:GuardianAngel inPlayerSet:_state.playersAlive];
        player = (guardianAngel) ? guardianAngel : player;
    }
    else if (player.role.roleType == Vampire)
    {
        Player *igor = [_state playerWithRole:Igor inPlayerSet:_state.playersAlive];
        player = (igor) ? igor : player;
    }
    
    // Kill target
    [destinedToDie addObject:player];
    _state.destinedToDie = destinedToDie;
    
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

-(void)angelPicksGuarded:(Player *)player
{
    _state.guardedPlayer = player;
}

#pragma mark - It is morning

-(MorningNews *)transitionToMorning
{
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
    [_state.destinedToDie makeObjectsPerformSelector:@selector(setAlive:) withObject:@NO];
    _state.destinedToDie = @[];
    
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

-(BOOL)gameIsOver
{
    NSArray *factionsInPlay = [_state.playersAlive valueForKeyPath:@"role.faction"];
    NSSet *factionSet = [NSSet setWithArray:factionsInPlay];
    
    //Wolf win
    if ([factionSet isEqualToSet:[NSSet setWithArray:@[@(WolvesFaction)]]])
        return YES;
    
    //Vampire win
    if ([factionSet isEqualToSet:[NSSet setWithArray:@[@(VampireFaction)]]])
        return YES;

    //Village wins if no shadows in play
    return ![self shadowsInPlay];
}

-(BOOL)shadowsInPlay
{
    NSPredicate *shadowFilter = [NSPredicate predicateWithBlock:^BOOL(Player *evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.role.isShadow;
    }];
    NSArray *shadowsInPlay = [_state.playersAlive filteredArrayUsingPredicate:shadowFilter];
    
    return shadowsInPlay.count > 0;
}

-(NSSet*)factionsWhichWon
{
    if (![self gameIsOver])
    {
        return [NSSet set];
    }
    
    NSArray *factionsInPlay = [_state.playersAlive valueForKeyPath:@"role.faction"];
    
    //Include dead madman/jester
    factionsInPlay = [factionsInPlay arrayByAddingObjectsFromArray:_state.winningFactions];
    
    //Include village if no shadows in play (and not already included)
    if (![self shadowsInPlay])
    {
        factionsInPlay = [factionsInPlay arrayByAddingObject:@(VillageFaction)];
    }
    
    //Remove duplicates and ignore ordering
    return [NSSet setWithArray:factionsInPlay];
}

@end
