//
//  BallotSecondRoundResultsViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 30/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallotSecondRoundResultsViewController : UIViewController

@property (nonatomic, strong) NSArray *voteResults;

@property (strong, nonatomic) IBOutlet UILabel *ballotResult;
@property (strong, nonatomic) IBOutlet UILabel *expectedVotes;
@property (strong, nonatomic) IBOutlet UILabel *actualVotes;

- (IBAction)redoRound:(id)sender;
- (IBAction)continuing:(id)sender;

@end
