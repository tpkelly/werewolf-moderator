//
//  BallotSecondRoundResultsViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 30/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "BallotSecondRoundResultsViewController.h"
#import "Vote.h"
#import "BallotManager.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Game.h"
#import "Player.h"
#import "Role.h"
#import "Ballot.h"
#import "BallotSecondRoundViewController.h"

@interface BallotSecondRoundResultsViewController ()

@property (nonatomic, strong) Player *burnedPlayer;

@end

@implementation BallotSecondRoundResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.actualVotes.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self actualVoteCount]];
    self.expectedVotes.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self expectedVoteCount]];
    self.ballotResult.text = [self burnedPlayerName];
    
    if ([SingleGame game].gameIsOver)
    {
        [self performSegueWithIdentifier:@"GameOver" sender:self];
    }
}

-(NSUInteger)expectedVoteCount
{
    NSUInteger totalVotes = 0;
    for (Vote *vote in self.voteResults.votes)
    {
        totalVotes++;
        if (vote.player.role.roleType == Seducer)
        {
            totalVotes--;
        }
    }
    
    return [SingleGame state].playersAlive.count - totalVotes;
}

-(NSUInteger)actualVoteCount
{
    NSUInteger total = 0;
    for (Vote *vote in self.voteResults.votes)
    {
        total += vote.voteCount;
    }
    return total;
}

-(NSString*)burnedPlayerName
{
    BallotManager *ballot = [[BallotManager alloc] initWithState:[SingleGame state]];
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
        for (Vote *vote in self.voteResults.votes)
        {
            [allPlayers addObject:vote.player];
        }
        
        nextViewController.playersOnBallot = [allPlayers copy];
    }
}

@end
