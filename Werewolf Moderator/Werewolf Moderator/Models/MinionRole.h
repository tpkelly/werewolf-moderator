//
//  MinionRole.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 01/02/2015.
//  Copyright (c) 2015 TKGames. All rights reserved.
//

#import "Role.h"

@interface MinionRole : Role

-(instancetype)initWithPreviousRole:(Role*)role;

@end
