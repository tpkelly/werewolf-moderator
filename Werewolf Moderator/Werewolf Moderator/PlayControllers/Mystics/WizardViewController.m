//
//  WizardViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 23/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "WizardViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Game.h"
#import "Player.h"

@interface WizardViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation WizardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[SingleGame state] roleIsAlive:Wizard])
    {
        self.alivePlayersTable.dataSource = self;
        self.alivePlayersTable.delegate = self;
    }
    else
    {
        self.alivePlayersTable.hidden = YES;
        [self.mysticImage setImage:[UIImage imageNamed:@"notInPlay.png"]];
    }
}

- (IBAction)continue:(id)sender
{
    if ([SingleGame state].isFirstNight)
    {
        [self performSegueWithIdentifier:@"MonkPrep" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"Witch" sender:self];
    }
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
    self.alivePlayersTable.hidden = YES;
    
    if ([[SingleGame game] wizardChecksPlayer:playerAtIndex])
    {
        [self.mysticImage setImage:[UIImage imageNamed:@"mystic.png"]];
    }
    else
    {
        [self.mysticImage setImage:[UIImage imageNamed:@"nonmystic.png"]];
    }
}

@end
