//
//  PlayViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 22/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "PlayViewController.h"

@implementation PlayViewController

- (IBAction)startGame:(id)sender
{
    [self performSegueWithIdentifier:@"Clairvoyant" sender:self];
}
@end
