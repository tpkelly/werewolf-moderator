//
//  VampireAttackViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 01/12/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VampireAttackViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *playerTable;
@property (strong, nonatomic) IBOutlet UIImageView *playerImmunityImage;
@property (strong, nonatomic) IBOutlet UILabel *tapPlayerLabel;

- (IBAction)continuing:(id)sender;

@end
