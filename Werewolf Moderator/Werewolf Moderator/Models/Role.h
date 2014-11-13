//
//  Role.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 12/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Faction) {
    WolvesFaction,
    VillageFaction,
    VampireFaction,
    JesterFaction,
    MadmanFaction,
    LoverFaction
};

typedef NS_ENUM(NSInteger, RoleType) {
    AlphaWolf,
    PackWolf,
    WolfPup,
    Defector,
    Clairvoyant,
    Medium,
    Wizard,
    Witch,
    Healer,
    Farmer,
    Hermit,
    Bard,
    Innkeeper,
    Monk,
    Priest,
    Sinner,
    Seducer,
    Madman,
    Jester,
    Juliet,
    GuardianAngel,
    Vampire,
    Minion,
    Igor,
    VampireHunter
};


@interface Role : NSObject

-(instancetype)initWithRole:(RoleType)roleType;

@property (nonatomic, readonly) BOOL isMystic;
@property (nonatomic, readonly) BOOL isCorrupt;
@property (nonatomic, readonly) Faction faction;

@end
