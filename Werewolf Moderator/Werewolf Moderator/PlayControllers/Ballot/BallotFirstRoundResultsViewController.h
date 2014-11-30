//
//  BallotFirstRoundResultsViewController.h
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 30/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallotFirstRoundResultsViewController : UIViewController

@property (nonatomic, strong) NSArray *playersOnBallot;
@property (nonatomic, assign) NSUInteger actualVoteCount;

@property (strong, nonatomic) IBOutlet UITableView *playersOnBallotTable;
@property (strong, nonatomic) IBOutlet UILabel *expectedVotesLabel;
@property (strong, nonatomic) IBOutlet UILabel *actualVotesLabel;

- (IBAction)redoRound:(id)sender;
- (IBAction)secondRound:(id)sender;

@end
