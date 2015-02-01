//
//  GuardedRole.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 01/02/2015.
//  Copyright (c) 2015 TKGames. All rights reserved.
//

#import "GuardedRole.h"

@interface GuardedRole ()

@property (nonatomic, strong) Role *underlyingRole;

@end

@implementation GuardedRole

-(instancetype)initWithPreviousRole:(Role *)role
{
    self = [super initWithRole:role.roleType];
    if (self)
    {
        self.underlyingRole = role;
    }
    return self;
}

-(NSString *)name
{
    return [NSString stringWithFormat:@"%@, Guarded", self.underlyingRole.name];
}

@end
