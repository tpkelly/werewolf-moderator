//
//  WizardViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 23/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WizardViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *alivePlayersTable;
@property (strong, nonatomic) IBOutlet UIImageView *mysticImage;

- (IBAction)continue:(id)sender;

@end
