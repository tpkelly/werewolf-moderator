//
//  MediumViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 23/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "MediumViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Player.h"
#import "Game.h"

@interface MediumViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MediumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[SingleGame state] roleIsAlive:Medium])
    {
        self.deadPlayersTable.dataSource = self;
        self.deadPlayersTable.delegate = self;
    }
    else
    {
        self.deadPlayersTable.hidden = YES;
        [self.corruptImage setImage:[UIImage imageNamed:@"notInPlay.png"]];
    }
}

- (IBAction)continue:(id)sender
{
    [self performSegueWithIdentifier:@"Wizard" sender:self];
}

#pragma mark - UITableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SingleGame state].playersDead.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerDead"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"playerDead"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Player *player = [[SingleGame state].playersDead objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *playerAtIndex = [[SingleGame state].playersDead objectAtIndex:indexPath.row];
    self.deadPlayersTable.hidden = YES;
    
    if ([[SingleGame game] mediumChecksPlayer:playerAtIndex])
    {
        [self.corruptImage setImage:[UIImage imageNamed:@"corrupt.png"]];
    }
    else
    {
        [self.corruptImage setImage:[UIImage imageNamed:@"noncorrupt.png"]];
    }
}

@end
