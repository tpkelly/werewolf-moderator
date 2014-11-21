//
//  GameController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 20/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "SingleGame.h"
#import "Game.h"
#import "GameState.h"

@interface SingleGame()


@end

@implementation SingleGame

+(instancetype)sharedGame
{
    static SingleGame *gameController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gameController = [self new];
    });
    return gameController;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        GameState *state = [GameState new];
        self.game = [[Game alloc] initWithState:state];
    }
    return self;
}

+(Game *)game
{
    return [SingleGame sharedGame].game;
}

+(GameState *)state
{
    return [SingleGame game].state;
}

@end
