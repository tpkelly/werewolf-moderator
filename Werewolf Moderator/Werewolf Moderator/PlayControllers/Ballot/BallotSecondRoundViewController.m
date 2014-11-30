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
#import "BallotSecondRoundResultsViewController.h"

@interface BallotSecondRoundViewController ()

@property (nonatomic, strong) NSMutableArray *playersWithoutVotes;
@property (nonatomic, strong) NSMutableArray *votesForPlayers;
@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong) Player *playerOnVote;

@end

@implementation BallotSecondRoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.playersWithoutVotes = [self.playersOnBallot mutableCopy];
    self.votesForPlayers = [NSMutableArray array];
    
    self.formatter = [NSNumberFormatter new];
    [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    //Get the ball rolling
    [self submitVotes:nil];
    
    //Allow "tap outside to dismiss keyboard"
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (IBAction)submitVotes:(id)sender {
    if (self.playerOnVote)
    {
        NSNumber *voteCount = [self.formatter numberFromString:self.playerVotes.text];
        voteCount = (voteCount) ? voteCount : @0;
        Vote *vote = [Vote forPlayer:self.playerOnVote voteCount:[voteCount integerValue]];
        [self.votesForPlayers addObject:vote];
    }
    
    if (self.playersWithoutVotes.count == 0)
    {
        [self performSegueWithIdentifier:@"Results" sender:self];
        return;
    }
    
    self.playerOnVote = [self.playersWithoutVotes firstObject];
    [self.playersWithoutVotes removeObject:self.playerOnVote];
    
    self.playerVoteLabel.text = [NSString stringWithFormat:@"Votes for %@", self.playerOnVote.name];
    self.playerVotes.text = @"";
}

-(void)dismissKeyboard
{
    [self.playerVotes resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Results"])
    {
        BallotSecondRoundResultsViewController *nextViewController = segue.destinationViewController;
        nextViewController.voteResults = [self.votesForPlayers copy];
    }
}

@end
