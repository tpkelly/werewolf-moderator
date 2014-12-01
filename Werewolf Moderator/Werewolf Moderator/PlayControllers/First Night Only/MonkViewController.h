//
//  MonkViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 23/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonkViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *firstUnassignedRole;
@property (strong, nonatomic) IBOutlet UILabel *secondUnassignedRole;

-(void)setupForFirstRole:(NSString*)firstRole secondRole:(NSString*)secondRole;

- (IBAction)continuing:(id)sender;

@end
