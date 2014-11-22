//
//  SecondViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 12/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "PlayStateViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Player.h"
#import "Role.h"

@interface PlayStateViewController () <UITableViewDataSource>

@end

@implementation PlayStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.playerTable.dataSource = self;
    self.playerTable.backgroundColor = [UIColor blackColor];
}

#pragma mark - UITableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SingleGame state].allPlayers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"player"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"player"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Player *player = [[SingleGame state].allPlayers objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", player.name, player.role.name];
    cell.textLabel.textColor = (player.alive)
      ? [UIColor colorWithRed:42.0/255 green:162.0/255 blue:95.0/255 alpha:1.0]
      : [UIColor redColor];
    
    return cell;
}

@end
