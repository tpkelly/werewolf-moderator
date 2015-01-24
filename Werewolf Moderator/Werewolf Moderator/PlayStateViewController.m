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

@interface PlayStateViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIAlertView *resetAlert;
@property (nonatomic, strong) UIAlertView *alterPlayerAlert;
@property (nonatomic, strong) Player *selectedPlayer;

@end

@implementation PlayStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.playerTable.delegate = self;
    self.playerTable.dataSource = self;
    self.playerTable.backgroundColor = [UIColor blackColor];
    
    self.resetAlert = [[UIAlertView alloc] initWithTitle:@"Reset Game" message:@"Are you sure you want to reset the game?" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Confirm",nil];
    self.alterPlayerAlert = [[UIAlertView alloc] initWithTitle:@"Alter Player" message:@"Set the new player state" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Alive", @"Destined to Die", @"Dead",nil];
    
    [self.doneButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.playerTable reloadData];
    [self donePressed];
}

#pragma mark - Editing table

-(void)beginEditing
{
    self.doneButton.hidden = NO;
    self.playerTable.editing = YES;
}

-(void)donePressed
{
    self.doneButton.hidden = YES;
    self.playerTable.editing = NO;
}

#pragma mark - Game Reset

-(void)resetGame:(id)sender
{

    [self.resetAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Dismiss"])
        return;
    
    if (alertView == self.resetAlert)
    {
        //Definitely going to reset the game
        [SingleGame reset];
        
        UIViewController *initial = [self.storyboard instantiateInitialViewController];
        [self presentViewController:initial animated:NO completion:nil];
    }
    else if (alertView == self.alterPlayerAlert)
    {
        if ([buttonTitle isEqualToString:@"Alive"])
        {
            self.selectedPlayer.alive = YES;
            [self player:self.selectedPlayer destinedToDie:NO];
        }
        else if ([buttonTitle isEqualToString:@"Destined to Die"])
        {
            self.selectedPlayer.alive = YES;
            [self player:self.selectedPlayer destinedToDie:YES];
        }
        else if ([buttonTitle isEqualToString:@"Dead"]) {
            self.selectedPlayer.alive = NO;
            [self player:self.selectedPlayer destinedToDie:NO];
        }
    
        self.selectedPlayer = nil;
        [self.playerTable reloadData];
    }
}

-(void)player:(Player*)player destinedToDie:(BOOL)destinedToDie
{
    NSMutableArray *destined = [[SingleGame state].destinedToDie mutableCopy];
    if (destinedToDie)
    {
        [destined addObject:self.selectedPlayer];
    }
    else
    {
        [destined removeObject:self.selectedPlayer];
    }
    [SingleGame state].destinedToDie = [destined copy];
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
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(beginEditing)];
        longPress.delegate = self;
        [cell addGestureRecognizer:longPress];
    }
    
    Player *player = [[SingleGame state].allPlayers objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", player.name, player.role.name];
    cell.textLabel.textColor = [self playerColor:player];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedPlayer = [[SingleGame state].allPlayers objectAtIndex:indexPath.row];
    [self.alterPlayerAlert show];
    //Remove the highlighting
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableArray *allPlayers = [[SingleGame state].allPlayers mutableCopy];
    Player *playerToMove = [allPlayers objectAtIndex:sourceIndexPath.row];
    
    NSUInteger destIndex = destinationIndexPath.row;
    //if (sourceIndexPath.row < destIndex)
    //    destIndex--;
    
    [allPlayers removeObject:playerToMove];
    [allPlayers insertObject:playerToMove atIndex:destIndex];
    [SingleGame state].allPlayers = [allPlayers copy];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableArray *playersCopy = [[SingleGame state].allPlayers mutableCopy];
        
        Player *deletedPlayer = [playersCopy objectAtIndex:indexPath.row];
        [[SingleGame state].unassignedRoles addObject:@(deletedPlayer.role.roleType)];
        
        [playersCopy removeObjectAtIndex:indexPath.row];
        [SingleGame state].allPlayers = [playersCopy copy];
        [tableView reloadData];
    }
}

-(UIColor*)playerColor:(Player*)player
{
    if ([[SingleGame state].destinedToDie containsObject:player])
        return [UIColor yellowColor];
    
    UIColor *werewolfGreen = [UIColor colorWithRed:42.0/255 green:162.0/255 blue:95.0/255 alpha:1.0];
    return (player.alive) ? werewolfGreen : [UIColor redColor];
}

#pragma mark - Gesture Delegates

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return !self.playerTable.editing;
}

@end
