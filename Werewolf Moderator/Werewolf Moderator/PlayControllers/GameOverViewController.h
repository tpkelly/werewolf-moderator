//
//  GameOverViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 02/12/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameOverViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *factionTable;
@property (strong, nonatomic) IBOutlet UITableView *factionWinTable;

@end
