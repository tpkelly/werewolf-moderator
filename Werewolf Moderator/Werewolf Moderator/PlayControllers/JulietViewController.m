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
#import "Player.h"

@interface JulietViewController () <UITableViewDataSource, UITableViewDelegate>

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
    
    self.romeoTable.dataSource = self;
    self.romeoTable.delegate = self;
}

- (IBAction)continuing:(id)sender {
    NSLog(@"Continue");
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"romeoPlayer"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"romeoPlayer"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    Player *player = [[SingleGame state].playersAlive objectAtIndex:indexPath.row];
    cell.textLabel.text = player.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *playerAtIndex = [[SingleGame state].playersAlive objectAtIndex:indexPath.row];
    self.romeoTable.hidden = YES;
    
    [[SingleGame game] julietPicksRomeo:playerAtIndex];
}

@end
