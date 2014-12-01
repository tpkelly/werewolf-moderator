//
//  WolfDoubleAttackViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 01/12/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "WolfDoubleAttackViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Game.h"
#import "Player.h"

@interface WolfDoubleAttackViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation WolfDoubleAttackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[SingleGame state] roleIsAlive:AlphaWolf] || [[SingleGame state] roleIsAlive:PackWolf])
    {
        self.firstPlayerTable.delegate = self;
        self.firstPlayerTable.dataSource = self;
        self.secondPlayerTable.delegate = self;
        self.secondPlayerTable.dataSource = self;
    }
    else
    {
        self.firstPlayerTable.hidden = YES;
        self.secondPlayerTable.hidden = YES;
        [self.firstPlayerImmunityImage setImage:[UIImage imageNamed:@"notInPlay.png"]];
        [self.secondPlayerImmunityImage setImage:[UIImage imageNamed:@"notInPlay.png"]];
    }
}

- (IBAction)continuing:(id)sender {
    [self performSegueWithIdentifier:@"Vampire" sender:self];
}

#pragma mark - UITableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SingleGame state].playersAlive.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wolfAttack"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wolfAttack"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Player *player = [[SingleGame state].playersAlive objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *playerAtIndex = [[SingleGame state].playersAlive objectAtIndex:indexPath.row];
    tableView.hidden = YES;
    
    if ([[SingleGame game] wolfAttackPlayer:playerAtIndex])
    {
        // Stop us killing the same person twice
        [self.firstPlayerTable reloadData];
        [self.secondPlayerTable reloadData];
        
        UILabel *tapLabel = (tableView == self.firstPlayerTable) ? self.tapFirstPlayerLabel : self.tapSecondPlayerLabel;
        // Use the destinedToDie array to check, in case someone took their place
        Player *attackedPlayer = [[SingleGame state].destinedToDie lastObject];
        tapLabel.text = [NSString stringWithFormat:@"Tap %@", attackedPlayer.name];
    }
    else
    {
        UIImageView *immunityImage = (tableView == self.firstPlayerTable) ? self.firstPlayerImmunityImage : self.secondPlayerImmunityImage;
        [immunityImage setImage:[UIImage imageNamed:@"immune.png"]];
    }
}

@end
