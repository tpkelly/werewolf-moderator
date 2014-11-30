//
//  BallotFirstRoundResultsViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 30/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "BallotFirstRoundResultsViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Player.h"
#import "BallotSecondRoundViewController.h"

@interface BallotFirstRoundResultsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation BallotFirstRoundResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.expectedVotesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[SingleGame state].playersAlive.count];
    self.actualVotesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self actualVoteCount]];
    
    self.playersOnBallotTable.delegate = self;
    self.playersOnBallotTable.dataSource = self;
}

- (IBAction)redoRound:(id)sender {
    [self performSegueWithIdentifier:@"Redo" sender:self];
}

- (IBAction)secondRound:(id)sender {
    [self performSegueWithIdentifier:@"SecondRound" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SecondRound"])
    {
        BallotSecondRoundViewController *nextViewController = segue.destinationViewController;
        nextViewController.playersOnBallot = self.playersOnBallot;
    }
}

#pragma mark - UITableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playersOnBallot.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"player"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"player"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Player *player = [self.playersOnBallot objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

@end
