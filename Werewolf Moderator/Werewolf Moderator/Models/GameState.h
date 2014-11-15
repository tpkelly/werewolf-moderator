//
//  GameState.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 13/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFromTheInn.h"

@class Player;

@interface GameState : NSObject

@property (nonatomic, copy) NSArray *playersAlive;
@property (nonatomic, copy) NSArray *playersDead;
@property (nonatomic, copy) NSArray *destinedToDie;
@property (nonatomic, copy) NSCountedSet *unassignedRoles;

@property (nonatomic, assign) BOOL madmanMauledLastNight;
@property (nonatomic, assign) BOOL jesterBurnedLastNight;
@property (nonatomic, assign) BOOL healerHasPowers;
@property (nonatomic, assign) NewsFromTheInn newsFromTheInn;

//Player picked by Juliet
@property (nonatomic, strong) Player *romeoPlayer;
//Player picked by Guardian Angel
@property (nonatomic, strong) Player *guardedPlayer;

-(void)addPlayer:(Player*)player;

@end
