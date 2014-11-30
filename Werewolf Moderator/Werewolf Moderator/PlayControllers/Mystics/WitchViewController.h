//
//  WitchViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 30/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WitchViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *playerTable;
@property (strong, nonatomic) IBOutlet UIImageView *witchInPlayImage;

- (IBAction)continuing:(id)sender;

@end
