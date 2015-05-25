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
@property (strong, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (strong, nonatomic) IBOutlet UIStepper *voteStepper;
@property (strong, nonatomic) IBOutlet UIButton *inquisitionButton;

- (IBAction)voteStep;
- (IBAction)submitVotes;
- (IBAction)inquisitionPower:(UIButton*)sender;

@end
