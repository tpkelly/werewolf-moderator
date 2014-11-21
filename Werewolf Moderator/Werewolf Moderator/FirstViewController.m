//
//  FirstViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 12/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "FirstViewController.h"
#import "SingleGame.h"
#import "Game.h"
#import "GameState.h"
#import "Role.h"
#import "Player.h"

@interface FirstViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.rolePicker.dataSource = self;
    self.rolePicker.delegate = self;
    
    [self.playerName addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.addPlayerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addPlayerButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
}

#pragma mark - UITextField methods

-(void)textDidChange:(UITextField*)textField
{
    [self allowSubmission:(textField.text.length > 0)];
}

-(void)allowSubmission:(BOOL)allow
{
    self.addPlayerButton.enabled = allow;
    self.addPlayerButton.backgroundColor = (allow) ? [UIColor colorWithRed:0 green:109.0/255.0 blue:204.0/255.0 alpha:1.0] : [UIColor lightGrayColor];
}

#pragma mark - UIPickerView methods

-(NSArray*)unassignedRoles
{
    return [[SingleGame state].unassignedRoles.allObjects sortedArrayUsingSelector:@selector(compare:)];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self unassignedRoles].count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    RoleType roleType = [[[self unassignedRoles] objectAtIndex:row] integerValue];
    Role *role = [[Role alloc] initWithRole:roleType];
    return role.name;
}

- (IBAction)submitPlayer:(UIButton *)sender
{
    NSUInteger selectedRow = [self.rolePicker selectedRowInComponent:0];
    RoleType role = [[[self unassignedRoles] objectAtIndex:selectedRow] integerValue];
    Player *newPlayer = [[Player alloc] initWithName:self.playerName.text role:role];
    
    [[SingleGame state] addPlayer:newPlayer];
    
    [self.rolePicker reloadComponent:0];
    self.playerName.text = @"";
    [self allowSubmission:NO];
}
@end
