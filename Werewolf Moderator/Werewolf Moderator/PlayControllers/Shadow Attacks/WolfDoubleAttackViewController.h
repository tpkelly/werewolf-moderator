//
//  WolfDoubleAttackViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 01/12/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WolfDoubleAttackViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *firstPlayerTable;
@property (strong, nonatomic) IBOutlet UIImageView *firstPlayerImmunityImage;
@property (strong, nonatomic) IBOutlet UILabel *tapFirstPlayerLabel;

@property (strong, nonatomic) IBOutlet UITableView *secondPlayerTable;
@property (strong, nonatomic) IBOutlet UIImageView *secondPlayerImmunityImage;
@property (strong, nonatomic) IBOutlet UILabel *tapSecondPlayerLabel;

- (IBAction)continuing:(id)sender;

@end
