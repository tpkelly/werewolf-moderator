//
//  WolfAttackViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 30/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "WolfAttackViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Game.h"
#import "Player.h"

@interface WolfAttackViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation WolfAttackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[SingleGame state] roleIsAlive:AlphaWolf] || [[SingleGame state] roleIsAlive:PackWolf])
    {
        self.playerTable.delegate = self;
        self.playerTable.dataSource = self;
    }
    else
    {
        self.playerTable.hidden = YES;
        [self.playerImmunityImage setImage:[UIImage imageNamed:@"notInPlay.png"]];
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
    self.playerTable.hidden = YES;
    
    if ([[SingleGame game] wolfAttackPlayer:playerAtIndex])
    {
        self.tapPlayerLabel.text = [NSString stringWithFormat:@"Tap %@", playerAtIndex.name];
    }
    else
    {
        [self.playerImmunityImage setImage:[UIImage imageNamed:@"immune.png"]];
    }
}

@end
