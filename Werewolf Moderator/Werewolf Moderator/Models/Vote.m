//
//  Vote.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 16/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "Vote.h"

@implementation Vote

+(instancetype)forPlayer:(Player *)player voteCount:(NSInteger)voteCount
{
    Vote *vote = [Vote new];
    vote.player = player;
    vote.voteCount = voteCount;
    return vote;
}

@end
