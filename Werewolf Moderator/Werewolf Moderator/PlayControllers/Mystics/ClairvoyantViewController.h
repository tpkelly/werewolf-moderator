//
//  ClairvoyantViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 22/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClairvoyantViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *alivePlayersTable;
@property (strong, nonatomic) IBOutlet UIImageView *corruptImage;

- (IBAction)continue:(id)sender;

@end
