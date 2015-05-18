//
//  Role.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 12/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "Role.h"

@implementation Role

-(instancetype)initWithRole:(RoleType)roleType
{
    self = [super init];
    if (self)
    {
        _roleType = roleType;
    }
    return self;
}

-(NSString *)description
{
    return self.name;
}

-(NSString *)name
{
    switch (self.roleType)
    {
        case AlphaWolf: return @"Alpha Wolf";
        case PackWolf: return @"Pack Wolf";
        case WolfPup: return @"Wolf Pup";
        case Defector: return @"Defector";
        case Clairvoyant: return @"Clairvoyant";
        case Medium: return @"Medium";
        case Wizard: return @"Wizard";
        case Witch: return @"Witch";
        case Healer: return @"Healer";
        case Farmer: return @"Farmer";
        case Hermit: return @"Hermit";
        case Bard: return @"Bard";
        case Innkeeper: return @"Innkeeper";
        case Monk: return @"Monk";
        case Priest: return @"Priest";
        case Sinner: return @"Sinner";
        case Seducer: return @"Seducer";
        case Madman: return @"Madman";
        case Jester: return @"Jester";
        case Juliet: return @"Juliet";
        case GuardianAngel: return @"Guardian Angel";
        case Vampire: return @"Vampire";
        case Minion: return @"Minion";
        case Igor: return @"Igor";
        case VampireHunter: return @"Vampire Hunter";
        case Hag: return @"Hag";
    }
}

-(BOOL)isCorrupt
{
    switch (self.roleType)
    {
        case AlphaWolf:
        case PackWolf:
        case WolfPup:
        case Sinner:
        case Seducer:
        case Vampire:
        case Minion:
        case Hag:
            return YES;
            
        default:
            return NO;
    }
}

-(BOOL)isMystic
{
    switch (self.roleType)
    {
        case Witch:
        case Healer:
        case Wizard:
        case Clairvoyant:
        case Medium:
        case Hag:
            return YES;
            
        default:
            return NO;
    }
}

-(BOOL)isShadow
{
    switch (self.roleType)
    {
        case AlphaWolf:
        case PackWolf:
        case WolfPup:
        case Vampire:
        case Minion:
        case Hag:
            return YES;
            
        default:
            return NO;
    }
}

-(Faction)faction
{
    switch (self.roleType)
    {
        case AlphaWolf:
        case PackWolf:
        case WolfPup:
            return WolvesFaction;
            
        case Vampire:
        case Minion:
            return VampireFaction;
            
        case Jester:
        case Madman:
        case Defector:
        case Hag:
        case Igor:
            return Factionless;
            
        case Juliet:
        case GuardianAngel:
            return LoverFaction;
            
        default:
            return VillageFaction;
    }
}

@end
