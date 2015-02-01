//
//  GameOverViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 02/12/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "GameOverViewController.h"
#import "SingleGame.h"
#import "Game.h"
#import "Faction.h"

@interface GameOverViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSSet *winningFactions;
@property (nonatomic, strong) NSArray *factionColours;

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.winningFactions = [SingleGame game].factionsWhichWon;
    
    self.factionTable.delegate = self;
    self.factionWinTable.delegate = self;
    self.factionTable.dataSource = self;
    self.factionWinTable.dataSource = self;
}

#pragma mark - UITableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.winningFactions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"faction"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"faction"];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];

    NSInteger factionIndex = [[[self.winningFactions allObjects] objectAtIndex:indexPath.row] integerValue];
    cell.textLabel.text = [self factionName:factionIndex];
    
    return cell;
}

-(NSString*)factionName:(NSInteger)factionIndex
{
    switch (factionIndex) {
        case 0: return @"Wolves";
        case 1: return @"Village";
        case 2: return @"Madman";
        case 3: return @"Jester";
        case 4: return @"Lovers";
        case 5: return @"Vampire";
    }
    
    return nil;
}

@end
