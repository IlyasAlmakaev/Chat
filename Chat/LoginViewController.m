//
//  LoginViewController.m
//  Chat
//
//  Created by almakaev iliyas on 16.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "LoginViewController.h"
#import "ProfileViewController.h"
#import <Quickblox/Quickblox.h>

@interface LoginViewController ()

- (IBAction)registration:(id)sender;
- (IBAction)logON:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) UITabBarController *tabController;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)registration:(id)sender
{
    [self enterProfile];
}

- (IBAction)logON:(id)sender
{
    QBUUser *user = [QBUUser user];
    user.password = self.passwordField.text;
    user.login = self.loginField.text;
    [self enterProfile];
}

- (void)enterProfile
{
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    
    UINavigationController *profileNC = [[UINavigationController alloc] initWithRootViewController:profileVC];
    
    profileNC.tabBarItem.title = @"Профиль";
    
    self.tabController = [[UITabBarController alloc] init];
    self.tabController.viewControllers = @[profileNC];
    
    [self presentViewController:self.tabController
                       animated:YES
                     completion:nil];
}

@end
