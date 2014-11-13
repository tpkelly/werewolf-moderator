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

-(NSString *)name
{
    switch (self.underlyingRole)
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
    }
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
