//
//  BallowSecondRoundViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 30/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallotSecondRoundViewController : UIViewController

@property (nonatomic, strong) NSArray *playersOnBallot;

@property (strong, nonatomic) IBOutlet UILabel *playerVoteLabel;
@property (strong, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (strong, nonatomic) IBOutlet UIStepper *voteStepper;

- (IBAction)voteStep;
- (IBAction)submitVotes;

@end
