//
//  BallotSecondRoundResultsViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 30/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "BallotSecondRoundResultsViewController.h"
#import "Vote.h"
#import "Ballot.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Game.h"
#import "Player.h"
#import "Role.h"
#import "BallotSecondRoundViewController.h"

@interface BallotSecondRoundResultsViewController ()

@property (nonatomic, strong) Player *burnedPlayer;

@end

@implementation BallotSecondRoundResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([SingleGame game].gameIsOver)
    {
        [self performSegueWithIdentifier:@"GameOver" sender:self];
    }
    
    // Do any additional setup after loading the view.
    self.actualVotes.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self actualVoteCount]];
    self.expectedVotes.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self expectedVoteCount]];
    self.ballotResult.text = [self burnedPlayerName];
}

-(NSUInteger)expectedVoteCount
{
    NSUInteger seducerAdjustment = 0;
    for (Vote *vote in self.voteResults)
    {
        if (vote.player.role.roleType == Seducer)
        {
            seducerAdjustment++;
        }
    }
    
    return [SingleGame state].playersAlive.count - self.voteResults.count + seducerAdjustment;
}

-(NSUInteger)actualVoteCount
{
    NSUInteger total = 0;
    for (Vote *vote in self.voteResults)
    {
        total += vote.voteCount;
    }
    return total;
}

-(NSString*)burnedPlayerName
{
    Ballot *ballot = [[Ballot alloc] initWithState:[SingleGame state]];
    self.burnedPlayer = [ballot secondRoundResults:self.voteResults];
    
    if (self.burnedPlayer)
    {
        return [NSString stringWithFormat:@"%@ died", self.burnedPlayer.name];
    }
    
    return @"Village undecided";
}

- (IBAction)redoRound:(id)sender {
    self.burnedPlayer.alive = YES;
    [self performSegueWithIdentifier:@"Redo" sender:self];
}

- (IBAction)continuing:(id)sender {
    [self performSegueWithIdentifier:@"Clairvoyant" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Redo"])
    {
        BallotSecondRoundViewController *nextViewController = segue.destinationViewController;
        
        NSMutableArray *allPlayers = [NSMutableArray array];
        for (Vote *vote in self.voteResults)
        {
            [allPlayers addObject:vote.player];
        }
        
        nextViewController.playersOnBallot = [allPlayers copy];
    }
}

@end
