//
//  BallotManager.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 15/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameState;
@class Player;
@class Ballot;

@interface BallotManager : NSObject

-(instancetype)initWithState:(GameState*)state;

//Takes arrays of Vote objects
-(NSArray*)firstRoundResults:(Ballot*)ballot;
-(Player*)secondRoundResults:(Ballot*)ballot;

@end
