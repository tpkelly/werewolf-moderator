//
//  BallowSecondRoundViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 30/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "BallotSecondRoundViewController.h"
#import "Player.h"
#import "Vote.h"
#import "Ballot.h"
#import "SingleGame.h"
#import "GameState.h"
#import "BallotSecondRoundResultsViewController.h"

@interface BallotSecondRoundViewController ()

@property (nonatomic, strong) NSMutableArray *playersWithoutVotes;
@property (nonatomic, strong) Ballot *ballot;
@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong) Player *playerOnVote;

@property (nonatomic, assign) NSInteger currentVoteCount;

@end

@implementation BallotSecondRoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.playersWithoutVotes = [self.playersOnBallot mutableCopy];
    self.ballot = [Ballot new];
    
    self.inquisitionButton.hidden = ![[SingleGame state] roleIsAlive:Executioner]
        || [[SingleGame state] playerWithRole:Executioner inPlayerSet:self.playersOnBallot];
    
    self.formatter = [NSNumberFormatter new];
    [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    //Get the ball rolling
    [self submitVotes];
}

- (IBAction)voteStep {
    self.currentVoteCount = self.voteStepper.value;
    self.voteCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.currentVoteCount];
}

- (IBAction)submitVotes {
    if (self.playerOnVote)
    {
        Vote *vote = [Vote forPlayer:self.playerOnVote voteCount:self.currentVoteCount];
        self.ballot.votes = [self.ballot.votes arrayByAddingObject:vote];
    }
    
    if (self.playersWithoutVotes.count == 0)
    {
        [self performSegueWithIdentifier:@"Results" sender:self];
        return;
    }
    
    self.playerOnVote = [self.playersWithoutVotes firstObject];
    [self.playersWithoutVotes removeObject:self.playerOnVote];
    
    if (self.ballot.inquisitionTarget)
        self.inquisitionButton.hidden = YES;
    
    self.playerVoteLabel.text = [NSString stringWithFormat:@"Votes for %@", self.playerOnVote.name];
    self.voteStepper.value = 0;
    [self voteStep];
}

- (IBAction)inquisitionPower:(UIButton*)button {
    if (self.ballot.inquisitionTarget)
    {
        self.ballot.inquisitionTarget = nil;
        button.alpha = 0.5;
    }
    else
    {
        self.ballot.inquisitionTarget = self.playerOnVote;
        button.alpha = 1.0;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Results"])
    {
        BallotSecondRoundResultsViewController *nextViewController = segue.destinationViewController;
        nextViewController.voteResults = self.ballot;
    }
}

@end
