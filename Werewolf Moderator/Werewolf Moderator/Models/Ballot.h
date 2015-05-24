//
//  Ballot.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 23/05/2015.
//  Copyright (c) 2015 TKGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Player;

@interface Ballot : NSObject

@property (nonatomic, strong) NSArray *votes;
@property (nonatomic, strong) Player *inquisitionTarget;

+(instancetype)ballotWithVotes:(NSArray*)votes;

@end
