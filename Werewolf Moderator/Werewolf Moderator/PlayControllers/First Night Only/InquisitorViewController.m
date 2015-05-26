//
//  InquisitorViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 25/05/2015.
//  Copyright (c) 2015 TKGames. All rights reserved.
//

#import "InquisitorViewController.h"
#import "SingleGame.h"
#import "GameState.h"

@implementation InquisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *mystics = [[[SingleGame state] playersAlive] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"role.isMystic == YES"]];
    self.mysticCountLabel.text = [NSString stringWithFormat:@"%lu Mystic(s)", (long unsigned)mystics.count];
}

- (IBAction)continuing:(id)sender
{
    [self performSegueWithIdentifier:@"MonkPrep" sender:self];
}

@end
