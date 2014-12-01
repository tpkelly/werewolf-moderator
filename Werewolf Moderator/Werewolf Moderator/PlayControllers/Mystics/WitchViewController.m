//
//  WitchViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 30/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "WitchViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Player.h"
#import "Game.h"

@interface WitchViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation WitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[SingleGame state] roleIsAlive:Witch])
    {
        self.playerTable.dataSource = self;
        self.playerTable.delegate = self;
    }
    else
    {
        [self.witchInPlayImage setImage:[UIImage imageNamed:@"NotInPlay.png"]];
        self.playerTable.hidden = YES;
    }
}

- (IBAction)continuing:(id)sender {
    [self performSegueWithIdentifier:@"Wolves" sender:self];
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
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *playerAtIndex = [[SingleGame state].playersAlive objectAtIndex:indexPath.row];
    self.playerTable.hidden = YES;
    
    [[SingleGame game] witchProtectPlayer:playerAtIndex];
}

@end
