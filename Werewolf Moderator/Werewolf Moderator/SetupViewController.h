//
//  FirstViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 12/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *playerName;
@property (strong, nonatomic) IBOutlet UIPickerView *rolePicker;
@property (strong, nonatomic) IBOutlet UIButton *addPlayerButton;

- (IBAction)submitPlayer:(id)sender;

@end

