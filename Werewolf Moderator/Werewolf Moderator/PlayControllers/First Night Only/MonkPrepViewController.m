//
//  MonkPrepViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 23/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "MonkPrepViewController.h"
#import "SingleGame.h"
#import "GameState.h"
#import "Role.h"
#import "MonkViewController.h"

@interface MonkPrepViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation MonkPrepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[SingleGame state] roleIsAlive:Monk])
    {
        //[self continue:nil];
    }
    
    // Do any additional setup after loading the view.
    self.monkRolePicker.dataSource = self;
    self.monkRolePicker.delegate = self;
}

- (IBAction)continue:(id)sender {
    [self performSegueWithIdentifier:@"Monk" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MonkViewController *monk = segue.destinationViewController;
    NSMutableArray *roles = [[self unassignedRoles] mutableCopy];
    
    NSString *firstRoleName = [self nameForComponent:0 roles:roles];
    NSString *secondRoleName = [self nameForComponent:1 roles:roles];
    
    [monk setupForFirstRole:firstRoleName secondRole:secondRoleName];
}

-(NSString*)nameForComponent:(NSInteger)component roles:(NSMutableArray*)roles
{
    NSInteger roleIndex = [self.monkRolePicker selectedRowInComponent:0];
    if (roleIndex >= roles.count)
    {
        return @"";
    }
    
    RoleType roleType = [[roles objectAtIndex:roleIndex] integerValue];
    [roles removeObject:@(roleType)];
    Role *role = [[Role alloc] initWithRole:roleType];
    return role.name;
}

#pragma mark - UIPickerView methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // All roles for Component 0, one less for Component 1
    return [SingleGame state].unassignedRoles.count - component;
}

-(NSArray*)unassignedRoles
{
    return [[SingleGame state].unassignedRoles.allObjects sortedArrayUsingSelector:@selector(compare:)];
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *roles = [self unassignedRoles];
    if (component == 1)
    {
        NSMutableArray *rolesWithoutFirst = [roles mutableCopy];
        NSUInteger firstComponentIndex = [pickerView selectedRowInComponent:0];
        [rolesWithoutFirst removeObjectAtIndex:firstComponentIndex];
        roles = [rolesWithoutFirst copy];
    }
    
    RoleType roleType = [[roles objectAtIndex:row] integerValue];
    Role *role = [[Role alloc] initWithRole:roleType];
    
    NSDictionary *attributes =
    @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:role.name attributes:attributes];
    
    return attString;
}

//Overrides default font sizing
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=3;
    }
    
    // Fill the label text here
    [tView setAttributedText:[self pickerView:pickerView attributedTitleForRow:row forComponent:component]];
    return tView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        // Picker 1 should not contain the value from picker 0
        [pickerView reloadComponent:1];
    }
}

@end
