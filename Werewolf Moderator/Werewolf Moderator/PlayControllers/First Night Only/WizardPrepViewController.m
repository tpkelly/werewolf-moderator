//
//  WizardPrepViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 25/05/2015.
//  Copyright (c) 2015 TKGames. All rights reserved.
//

#import "WizardPrepViewController.h"
#import "SingleGame.h"
#import "GameState.h"

@implementation WizardPrepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *imageName;
    
    if (![[SingleGame state] roleIsAlive:Wizard])
    {
        imageName = @"notInPlay.png";
    }
    else if ([[SingleGame state] roleIsAlive:Inquisitor])
    {
        imageName = @"inquisition.png";
    }
    else
    {
        imageName = @"noInquisition.png";
    }
    
    [self.inquisitionIsInPlayImage setImage:[UIImage imageNamed:imageName]];
}

- (IBAction)continuing:(id)sender {
    [self performSegueWithIdentifier:@"Inquisitor" sender:self];
}
@end
