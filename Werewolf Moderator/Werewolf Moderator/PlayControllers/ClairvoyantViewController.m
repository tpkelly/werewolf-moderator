//
//  ClairvoyantViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 22/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "ClairvoyantViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Game.h"
#import "Player.h"

@interface ClairvoyantViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ClairvoyantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[SingleGame state] roleIsAlive:Clairvoyant])
    {
        self.alivePlayersTable.dataSource = self;
        self.alivePlayersTable.delegate = self;
    }
    else
    {
        self.alivePlayersTable.hidden = YES;
        [self.corruptImage setImage:[UIImage imageNamed:@"notInPlay.png"]];
    }
}

- (IBAction)continue:(id)sender
{
    NSLog(@"Continuing");
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerAlive"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"playerAlive"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Player *player = [[SingleGame state].playersAlive objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *playerAtIndex = [[SingleGame state].playersAlive objectAtIndex:indexPath.row];
    self.alivePlayersTable.hidden = YES;
    
    if ([[SingleGame game] clairvoyantChecksPlayer:playerAtIndex])
    {
        [self.corruptImage setImage:[UIImage imageNamed:@"corrupt.png"]];
    }
    else
    {
        [self.corruptImage setImage:[UIImage imageNamed:@"noncorrupt.png"]];
    }
}

@end
