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
#import "Role.h"
#import "Game.h"

@interface AngelViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *possibleGuarded;

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
    
    self.possibleGuarded = [self potentialGuarded];
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
    return self.possibleGuarded.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"guardedPlayer"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"guardedPlayer"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Player *player = [self.possibleGuarded objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *playerAtIndex = [self.possibleGuarded objectAtIndex:indexPath.row];
    self.guardedTable.hidden = YES;
    
    [[SingleGame game] angelPicksGuarded:playerAtIndex];
}

-(NSArray*)potentialGuarded
{
    NSArray *allPlayers = [SingleGame state].playersAlive;
    NSArray *protectablePlayers = [allPlayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Player *player, NSDictionary *bindings) {
        return player.role.roleType != GuardianAngel;
    }]];
    return protectablePlayers;
}

@end
