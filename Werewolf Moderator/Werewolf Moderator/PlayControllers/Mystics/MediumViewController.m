//
//  MediumViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 23/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "MediumViewController.h"
#import "SingleGame.h"
#import "GameState.h"

@interface MediumViewController ()

@end

@implementation MediumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Medium not needed if nobody is dead
    if ([SingleGame state].playersDead.count == 0)
    {
        [self performSegueWithIdentifier:@"Wizard" sender:self];
    }
}

@end
