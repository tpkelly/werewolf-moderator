//
//  Role.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 12/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "Role.h"

@interface Role()

@property (nonatomic, assign) RoleType underlyingRole;

@end

@implementation Role

-(instancetype)initWithRole:(RoleType)roleType
{
    self = [super init];
    if (self)
    {
        self.underlyingRole = roleType;
    }
    return self;
}

-(BOOL)isCorrupt
{
    switch (self.underlyingRole)
    {
        case AlphaWolf:
        case PackWolf:
        case WolfPup:
        case Sinner:
        case Seducer:
        case Vampire:
        case Minion:
            return true;
            
        default:
            return false;
    }
}

-(BOOL)isMystic
{
    switch (self.underlyingRole)
    {
        case Witch:
        case Healer:
        case Wizard:
        case Clairvoyant:
        case Medium:
            return true;
            
        default:
            return false;
    }
}

-(Faction)faction
{
    switch (self.underlyingRole)
    {
        case AlphaWolf:
        case PackWolf:
        case WolfPup:
        case Defector:
            return WolvesFaction;
            
        case Vampire:
        case Igor:
        case Minion:
            return VampireFaction;
            
        case Jester:
            return JesterFaction;
            
        case Madman:
            return MadmanFaction;
            
        case Juliet:
        case GuardianAngel:
            return LoverFaction;
            
        default:
            return VillageFaction;
    }
}

@end
