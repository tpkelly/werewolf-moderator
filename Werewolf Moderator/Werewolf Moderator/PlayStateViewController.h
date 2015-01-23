//
//  SecondViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 12/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayStateViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *playerTable;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)resetGame:(id)sender;

@end

