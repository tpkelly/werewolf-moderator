//
//  VampireAttackViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 01/12/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "VampireAttackViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Game.h"
#import "Player.h"

@interface VampireAttackViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation VampireAttackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[SingleGame state] roleIsAlive:Vampire])
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
    [self performSegueWithIdentifier:@"Healer" sender:self];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vampAttack"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"vampAttack"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Player *player = [[SingleGame state].playersAlive objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *playerAtIndex = [[SingleGame state].playersAlive objectAtIndex:indexPath.row];
    self.playerTable.hidden = YES;
    
    if ([[SingleGame game] vampireAttackPlayer:playerAtIndex])
    {
        self.tapPlayerLabel.text = [NSString stringWithFormat:@"Tap %@", playerAtIndex.name];
    }
    else
    {
        [self.playerImmunityImage setImage:[UIImage imageNamed:@"immune.png"]];
    }
}


@end
