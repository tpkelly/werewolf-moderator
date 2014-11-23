//
//  MonkViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 23/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "MonkViewController.h"

@interface MonkViewController ()

@property (nonatomic, strong) NSString *firstRole;
@property (nonatomic, strong) NSString *secondRole;

@end

@implementation MonkViewController

-(void)setupForFirstRole:(NSString *)firstRole secondRole:(NSString *)secondRole
{
    self.firstRole = firstRole;
    self.secondRole = secondRole;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstUnassignedRole.text = [NSString stringWithFormat:@"\n\n\n\n\n\n%@", self.firstRole];
    self.secondUnassignedRole.text = [NSString stringWithFormat:@"\n\n\n\n\n\n%@", self.secondRole];
}

- (IBAction)continuing:(id)sender {
    NSLog(@"Continue");
}
@end
