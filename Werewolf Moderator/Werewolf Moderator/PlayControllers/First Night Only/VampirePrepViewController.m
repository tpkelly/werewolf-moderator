//
//  VampirePrepViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 25/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "VampirePrepViewController.h"

@implementation VampirePrepViewController

- (IBAction)continuing:(id)sender {
    [self performSegueWithIdentifier:@"Morning" sender:self];
}
@end
