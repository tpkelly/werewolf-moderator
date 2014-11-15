//
//  Game.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 14/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameState;
@class Player;

@interface Game : NSObject

-(instancetype)initWithState:(GameState*)state;

@property (nonatomic, readonly) GameState *state;

-(BOOL)clairvoyantChecksPlayer:(Player*)player;
-(BOOL)wizardChecksPlayer:(Player*)player;
-(BOOL)mediumChecksPlayer:(Player*)player;

-(void)witchProtectPlayer:(Player*)player;
-(void)healerSavesPlayer:(Player*)player;

-(void)vampireAttackPlayer:(Player*)player;
-(void)wolfAttackPlayer:(Player*)player;

@end
