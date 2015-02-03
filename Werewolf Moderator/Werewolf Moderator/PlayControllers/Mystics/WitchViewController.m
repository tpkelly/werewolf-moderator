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
#import "Role.h"
#import "Game.h"

@interface WitchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *protectablePlayers;

@end

@implementation WitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[SingleGame state] roleIsAlive:Witch])
    {
        self.protectablePlayers = [self allProtectablePlayers];
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
    if ([SingleGame state].wolvesAttackTwice)
    {
        [self performSegueWithIdentifier:@"WolvesDouble" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"Wolves" sender:self];
    }
}

#pragma mark - UITableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.protectablePlayers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerAlive"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"playerAlive"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Player *player = [self.protectablePlayers objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *playerAtIndex = [self.protectablePlayers objectAtIndex:indexPath.row];
    self.playerTable.hidden = YES;
    
    [[SingleGame game] witchProtectPlayer:playerAtIndex];
}

-(NSArray*)allProtectablePlayers
{
    NSArray *allPlayers = [SingleGame state].playersAlive;
    NSArray *protectablePlayers = [allPlayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Player *player, NSDictionary *bindings) {
        return player.role.roleType != Witch;
    }]];
    return protectablePlayers;
}

@end
