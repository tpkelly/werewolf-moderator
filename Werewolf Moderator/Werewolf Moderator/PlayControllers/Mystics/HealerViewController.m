//
//  HealerViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 01/12/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "HealerViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Role.h"
#import "Game.h"
#import "Player.h"

@interface HealerViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HealerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([SingleGame state].healerHasPowers && [[SingleGame state] roleIsAlive:Healer])
    {
        self.destinedToDieTable.delegate = self;
        self.destinedToDieTable.dataSource = self;
    }
    else
    {
        self.savePlayerButton.hidden = YES;
        [self.healerInPlayImage setImage:[UIImage imageNamed:@"notInPlay.png"]];
    }
}

- (IBAction)healPlayer:(id)sender {
    self.destinedToDieTable.hidden = NO;
}

- (IBAction)continuing:(id)sender {
    [self performSegueWithIdentifier:@"Morning" sender:self];
}

#pragma mark - UITableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SingleGame state].destinedToDie.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"healerSave"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"healerSave"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Player *player = [[SingleGame state].destinedToDie objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *playerAtIndex = [[SingleGame state].destinedToDie objectAtIndex:indexPath.row];
    [[SingleGame game] healerSavesPlayer:playerAtIndex];
    
    if (playerAtIndex.role.roleType == Inquisitor)
    {
        [self.healerInPlayImage setImage:[UIImage imageNamed:@"alertInquisitor.png"]];
    }
    
    [self continuing:nil];
}


@end
