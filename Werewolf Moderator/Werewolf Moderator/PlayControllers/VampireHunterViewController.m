//
//  VampireHunterViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 25/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "VampireHunterViewController.h"
#import "SingleGame.h"
#import "GameState.h"

@implementation VampireHunterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *imageName;
    if (![[SingleGame state] roleIsAlive:VampireHunter])
    {
        imageName = @"notInPlay.png";
    }
    else if ([[SingleGame state] roleIsAlive:Vampire])
    {
        imageName = @"vampire.png";
    }
    else
    {
        imageName = @"noVampire.png";
    }
                                          
    [self.vampireInPlayImage setImage:[UIImage imageNamed:imageName]];
    
}

- (IBAction)continuing:(id)sender {
    NSLog(@"Continue");
}
@end
