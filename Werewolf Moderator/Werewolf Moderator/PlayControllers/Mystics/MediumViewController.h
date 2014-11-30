//
//  MediumViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 23/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediumViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *deadPlayersTable;
@property (strong, nonatomic) IBOutlet UIImageView *corruptImage;

- (IBAction)continue:(id)sender;

@end
