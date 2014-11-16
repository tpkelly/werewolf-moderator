//
//  Vote.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 16/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Player;

@interface Vote : NSObject

+(instancetype)forPlayer:(Player*)player voteCount:(NSInteger)voteCount;

@property (nonatomic, strong) Player *player;
@property (nonatomic, assign) NSInteger voteCount;

@end
