//
//  HealerViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 01/12/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *destinedToDieTable;
@property (strong, nonatomic) IBOutlet UIImageView *healerInPlayImage;
- (IBAction)healPlayer:(id)sender;

- (IBAction)continuing:(id)sender;

@end
