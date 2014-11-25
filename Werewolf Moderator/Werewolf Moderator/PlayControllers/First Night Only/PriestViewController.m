//
//  PriestViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 25/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "PriestViewController.h"
#import "SingleGame.h"
#import "GameState.h"

@interface PriestViewController ()

@end

@implementation PriestViewController

- (void)viewDidLoad {
    NSString *imageName;
    
    if (![[SingleGame state] roleIsAlive:Priest])
    {
        imageName = @"notInPlay.png";
    }
    else if ([[SingleGame state] roleIsAlive:Seducer])
    {
        imageName = @"seducer.png";
    }
    else
    {
        imageName = @"noSeducer.png";
    }
    
    [self.seducerInPlayImage setImage:[UIImage imageNamed:imageName]];
}


- (IBAction)continuing:(id)sender {
    [self performSegueWithIdentifier:@"Juliet" sender:self];
}
@end
