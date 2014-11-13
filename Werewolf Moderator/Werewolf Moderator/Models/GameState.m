//
//  GameState.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 13/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "GameState.h"

@implementation GameState

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.healerHasPowers = YES;
        self.newsFromTheInn = NoNews;
        
        self.destinedToDie = [NSArray array];
        self.playersAlive = [NSArray array];
        self.playersDead = [NSArray array];
        
        NSArray *initialRoles = @[@(AlphaWolf),
                                  @(PackWolf),
                                  @(WolfPup),
                                  @(Defector),
                                  @(Clairvoyant),
                                  @(Medium),
                                  @(Wizard),
                                  @(Witch),
                                  @(Healer),
                                  @(Farmer),
                                  @(Farmer),
                                  @(Hermit),
                                  @(Bard),
                                  @(Innkeeper),
                                  @(Monk),
                                  @(Priest),
                                  @(Sinner),
                                  @(Seducer),
                                  @(Madman),
                                  @(Jester),
                                  @(Juliet),
                                  @(GuardianAngel),
                                  @(Vampire),
                                  @(Igor),
                                  @(VampireHunter)
                                  ];
        
        self.unassignedRoles = [NSCountedSet setWithArray:initialRoles];
    }
    return self;
}

-(void)addPlayer:(Player *)player
{
    if (![self.unassignedRoles containsObject:@(player.role.roleType)])
    {
        @throw [NSException exceptionWithName:@"NoSuchRoleAvailable" reason:@"The role cannot be added to this session, as it is not part of the list of unassigned roles" userInfo:nil];
    }
    
    self.playersAlive = [self.playersAlive arrayByAddingObject:player];
    [_unassignedRoles removeObject:@(player.role.roleType)];
}

@end
