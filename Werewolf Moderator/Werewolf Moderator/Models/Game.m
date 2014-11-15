//
//  Game.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 14/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "Game.h"

@implementation Game

-(instancetype)initWithState:(GameState *)state
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Mystic Abilities

-(BOOL)clairvoyantChecksPlayer:(Player *)player
{
    return YES;
}

-(BOOL)mediumChecksPlayer:(Player *)player
{
    return YES;
}

-(BOOL)wizardChecksPlayer:(Player *)player
{
    return YES;
}

-(void)witchProtectPlayer:(Player *)player
{
    
}

-(void)healerSavesPlayer:(Player *)player
{
    
}

#pragma mark - Nightly attacks

-(void)wolfAttackPlayer:(Player *)player
{
    
}

-(void)vampireAttackPlayer:(Player *)player
{
    
}

@end
