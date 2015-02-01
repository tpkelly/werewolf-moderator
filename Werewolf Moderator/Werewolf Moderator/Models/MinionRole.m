//
//  MinionRole.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 01/02/2015.
//  Copyright (c) 2015 TKGames. All rights reserved.
//

#import "MinionRole.h"

@interface MinionRole ()

@property (nonatomic, strong) Role *previousRole;

@end

@implementation MinionRole

-(instancetype)initWithPreviousRole:(Role *)role
{
    self = [super initWithRole:Minion];
    if (self)
    {
        self.previousRole = role;
    }
    return self;
}

-(NSString *)name
{
    return [NSString stringWithFormat:@"Minion, ex-%@", self.previousRole.name];
}

@end
