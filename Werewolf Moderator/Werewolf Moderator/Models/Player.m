//
//  Player.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 13/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "Player.h"
#import "Role.h"

@implementation Player

-(instancetype)initWithName:(NSString*)name role:(RoleType)roleType
{
    self = [super init];
    if (self)
    {
        _name = name;
        _role = [[Role alloc] initWithRole:roleType];
        
        _alive = true;
        _temporaryProtection = false;
        _permanentProtection = (roleType == Hermit);
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@)", self.name, self.role];
}

@end
