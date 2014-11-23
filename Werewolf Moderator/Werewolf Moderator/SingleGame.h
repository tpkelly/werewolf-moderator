//
//  GameController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 20/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;
@class GameState;

@interface SingleGame : NSObject

@property (nonatomic, strong) Game *game;

+(instancetype)sharedGame;
+(Game*)game;
+(GameState*)state;
+(void)reset;

@end
