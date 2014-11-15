//
//  MorningNews.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 15/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFromTheInn.h"

@interface MorningNews : NSObject

@property (nonatomic, assign) NewsFromTheInn news;
@property (nonatomic, copy) NSArray *diedLastNight;

@end
