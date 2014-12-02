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
    
    self.factionColours = @[[UIColor blackColor],
                            [UIColor colorWithRed:254.0/255 green:200.0/255 blue:130.0/255 alpha:1.0],
                            [UIColor colorWithRed:166.0/255 green:206.0/255 blue:227.0/255 alpha:1.0],
                            [UIColor colorWithRed:255.0/255 green:237.0/255 blue:111.0/255 alpha:1.0],
                            [UIColor colorWithRed:250.0/255 green:159.0/255 blue:181.0/255 alpha:1.0],
                            [UIColor colorWithRed:035.0/255 green:139.0/255 blue:069.0/255 alpha:1.0]];
    
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
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"faction"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"faction"];
    }
    
    if (tableView == self.factionTable)
    {
        cell.textLabel.text = [self factionName:indexPath.row];
        cell.backgroundColor = [self.factionColours objectAtIndex:indexPath.row];
        cell.textLabel.textColor = (indexPath.row == WolvesFaction) ? [UIColor whiteColor] : [UIColor blackColor];
    }
    else
    {
        BOOL factionWon = [self.winningFactions containsObject:@(indexPath.row)];
        cell.textLabel.text = @"";
        cell.backgroundColor = (factionWon)
            ? [UIColor colorWithRed:51.0/255 green:160.0/255 blue:44.0/255 alpha:1.0]
            : [UIColor colorWithRed:227.0/255 green:26.0/255 blue:28.0/255 alpha:1.0];
    }
    
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
