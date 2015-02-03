//
//  JulietViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 25/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "JulietViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Game.h"
#import "Role.h"
#import "Player.h"

@interface JulietViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *availablePlayers;

@end

@implementation JulietViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    if (![[SingleGame state] roleIsAlive:Juliet])
    {
        self.romeoTable.hidden = YES;
        return;
    }
    
    self.availablePlayers = [self suitors];
    self.romeoTable.dataSource = self;
    self.romeoTable.delegate = self;
}

- (IBAction)continuing:(id)sender {
    [self performSegueWithIdentifier:@"Angel" sender:self];
}

#pragma mark - UITableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.availablePlayers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"romeoPlayer"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"romeoPlayer"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Player *player = [self.availablePlayers objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *playerAtIndex = [self.availablePlayers objectAtIndex:indexPath.row];
    self.romeoTable.hidden = YES;
    
    [[SingleGame game] julietPicksRomeo:playerAtIndex];
}

-(NSArray*)suitors
{
    NSArray *allPlayers = [SingleGame state].playersAlive;
    NSArray *protectablePlayers = [allPlayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Player *player, NSDictionary *bindings) {
        return player.role.roleType != Juliet;
    }]];
    return protectablePlayers;
}

@end
