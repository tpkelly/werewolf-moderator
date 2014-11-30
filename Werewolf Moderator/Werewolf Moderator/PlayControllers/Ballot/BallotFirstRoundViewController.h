//
//  BallotViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 26/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallotFirstRoundViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *playerVoteLabel;
@property (strong, nonatomic) IBOutlet UITextField *playerVotes;

- (IBAction)submitVotes:(id)sender;

@end
