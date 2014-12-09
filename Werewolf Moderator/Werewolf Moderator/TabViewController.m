//
//  TabViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 09/12/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController () <UITabBarControllerDelegate, UITabBarDelegate>

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

#pragma mark - Tab Bar delegate methods

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //Don't allow reselection of the middle tab if already on it
    return (viewController != tabBarController.selectedViewController);
}


@end
