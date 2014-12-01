//
//  AngelViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 01/12/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "AngelViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Player.h"
#import "Game.h"

@interface AngelViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation AngelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    if (![[SingleGame state] roleIsAlive:GuardianAngel])
    {
        self.guardedTable.hidden = YES;
        return;
    }
    
    self.guardedTable.dataSource = self;
    self.guardedTable.delegate = self;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"guardedPlayer"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"guardedPlayer"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Player *player = [[SingleGame state].playersAlive objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *playerAtIndex = [[SingleGame state].playersAlive objectAtIndex:indexPath.row];
    self.guardedTable.hidden = YES;
    
    [[SingleGame game] angelPicksGuarded:playerAtIndex];
}

@end
