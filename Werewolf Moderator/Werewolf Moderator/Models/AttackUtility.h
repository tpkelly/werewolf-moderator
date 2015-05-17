//
//  AttackUtility.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 17/05/2015.
//  Copyright (c) 2015 TKGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KillReason.h"


@class Player;
@class GameState;

@interface AttackUtility : NSObject

+(Player*)killPlayer:(Player*)player reason:(KillReason)reason state:(GameState*)state;

@end
