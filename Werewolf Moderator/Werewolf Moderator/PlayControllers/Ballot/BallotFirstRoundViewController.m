//
//  BallotViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 26/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "BallotFirstRoundViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Player.h"
#import "Vote.h"
#import "Ballot.h"
#import "BallotFirstRoundResultsViewController.h"

@interface BallotFirstRoundViewController ()

@property (nonatomic, strong) NSMutableArray *playersWithoutVotes;
@property (nonatomic, strong) NSMutableArray *votesForPlayers;
@property (nonatomic, strong) Player *playerOnVote;
@property (nonatomic, strong) NSNumberFormatter *formatter;

@property (nonatomic, assign) NSInteger currentVoteCount;

@end

@implementation BallotFirstRoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.playersWithoutVotes = [[SingleGame state].playersAlive mutableCopy];
    self.votesForPlayers = [NSMutableArray array];
    
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
        [self.votesForPlayers addObject:vote];
    }

    if (self.playersWithoutVotes.count == 0)
    {
        [self performSegueWithIdentifier:@"FirstRound" sender:self];
        return;
    }
    
    self.playerOnVote = [self.playersWithoutVotes firstObject];
    [self.playersWithoutVotes removeObject:self.playerOnVote];
    
    self.playerVoteLabel.text = [NSString stringWithFormat:@"Votes for %@", self.playerOnVote.name];
    self.voteStepper.value = 0;
    [self voteStep];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FirstRound"])
    {
        BallotFirstRoundResultsViewController *nextViewController = segue.destinationViewController;
        Ballot *ballot = [[Ballot alloc] initWithState:[SingleGame state]];
        nextViewController.playersOnBallot = [ballot firstRoundResults:self.votesForPlayers];
        nextViewController.actualVoteCount = [self actualVoteCount];
    }
}

-(NSUInteger)actualVoteCount
{
    NSUInteger total = 0;
    for (Vote *vote in self.votesForPlayers)
    {
        total += vote.voteCount;
    }
    return total;
}

@end
