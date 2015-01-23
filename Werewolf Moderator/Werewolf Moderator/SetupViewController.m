//
//  FirstViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 12/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "SetupViewController.h"
#import "SingleGame.h"
#import "Game.h"
#import "GameState.h"
#import "Role.h"
#import "Player.h"

@interface SetupViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@end

@implementation SetupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.rolePicker.dataSource = self;
    self.rolePicker.delegate = self;
    
    [self.playerName addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.playerName.delegate = self;
    
    [self.addPlayerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addPlayerButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.rolePicker reloadAllComponents];
}

#pragma mark - UITextField methods

-(void)dismissKeyboard
{
    [self.playerName resignFirstResponder];
}

-(void)textDidChange:(UITextField*)textField
{
    [self allowSubmission:(textField.text.length > 0)];
}

-(void)allowSubmission:(BOOL)allow
{
    self.addPlayerButton.enabled = allow;
    self.addPlayerButton.backgroundColor = (allow) ? [UIColor colorWithRed:0 green:109.0/255.0 blue:204.0/255.0 alpha:1.0] : [UIColor lightGrayColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    RoleType roleType = [[[self unassignedRoles] objectAtIndex:row] integerValue];
    Role *role = [[Role alloc] initWithRole:roleType];
    
    NSDictionary *attributes =
      @{NSForegroundColorAttributeName:[UIColor whiteColor],
        NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:30]};
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:role.name attributes:attributes];
    
    return attString;
    
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
