//
//  Role.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 12/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "Faction.h"
#import "RoleType.h"
#import <Foundation/Foundation.h>

@interface Role : NSObject

-(instancetype)initWithRole:(RoleType)roleType;

-(NSString*)name;

@property (nonatomic, readonly) BOOL isMystic;
@property (nonatomic, readonly) BOOL isCorrupt;
@property (nonatomic, readonly) Faction faction;

@end
