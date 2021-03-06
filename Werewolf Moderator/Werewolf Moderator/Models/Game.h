//
//  Game.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 14/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFromTheInn.h"
#import "AttackResult.h"

@class GameState;
@class Player;
@class MorningNews;

@interface Game : NSObject

-(instancetype)initWithState:(GameState*)state;

@property (nonatomic, readonly) GameState *state;

-(BOOL)clairvoyantChecksPlayer:(Player*)player;
-(BOOL)wizardChecksPlayer:(Player*)player;
-(BOOL)mediumChecksPlayer:(Player*)player;

-(BOOL)witchProtectPlayer:(Player*)player;
-(void)healerSavesPlayer:(Player*)player;

-(void)julietPicksRomeo:(Player*)player;
-(void)angelPicksGuarded:(Player*)player;

// Returns whether the attack was successful
-(AttackResult)vampireAttackPlayer:(Player*)player;
-(AttackResult)wolfAttackPlayer:(Player*)player;

-(MorningNews*)transitionToMorning;
-(BOOL)gameIsOver;
-(NSSet*)factionsWhichWon;

@end
