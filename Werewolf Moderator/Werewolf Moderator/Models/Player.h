//
//  Player.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 13/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoleType.h"

@class Role;

@interface Player : NSObject

-(instancetype)initWithName:(NSString*)name role:(RoleType)roleType;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, strong) Role *role;
@property (nonatomic, assign) BOOL alive;

@property (nonatomic, assign) BOOL isCursed;
@property (nonatomic, assign) BOOL temporaryProtection;
@property (nonatomic, assign) BOOL permanentProtection;

@end
