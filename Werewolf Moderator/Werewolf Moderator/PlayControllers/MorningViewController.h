//
//  MorningViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 25/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MorningViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *newsFromTheInn;
@property (strong, nonatomic) IBOutlet UITextView *diedLastNight;
@property (strong, nonatomic) IBOutlet UILabel *morningtime;

- (IBAction)ballotTime:(id)sender;
@end
