//
//  MonkPrepViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 23/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonkPrepViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIPickerView *monkRolePicker;

- (IBAction)continue:(id)sender;

@end
