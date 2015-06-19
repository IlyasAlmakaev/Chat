//
//  LoginViewController.m
//  Chat
//
//  Created by almakaev iliyas on 16.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "CopmanionsTableViewController.h"
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
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        NSLog(@"Authorisation");
    } errorBlock:^(QBResponse *response) {
        NSLog(@"%@",[response.error description]);
    }];}

- (IBAction)registration:(id)sender
{
    [self enterProfile];
}

- (IBAction)logON:(id)sender
{
    // Authenticate user
    [QBRequest logInWithUserLogin:self.loginField.text password:self.passwordField.text
                     successBlock:[self successBlock] errorBlock:[self errorBlock]];
    
}

- (void (^)(QBResponse *response, QBUUser *user))successBlock
{
    return ^(QBResponse *response, QBUUser *user) {
        [self enterProfile];
    };
}

- (QBRequestErrorBlock)errorBlock
{
    return ^(QBResponse *response) {
        NSLog(@"%@", [response.error description]);
    };
}

- (void)enterProfile
{
    CopmanionsTableViewController *companionsTVC = [[CopmanionsTableViewController alloc] init];
    UINavigationController *companionsNC = [[UINavigationController alloc] initWithRootViewController:companionsTVC];
    companionsNC.tabBarItem.title = @"Собеседники";
    
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    UINavigationController *profileNC = [[UINavigationController alloc] initWithRootViewController:profileVC];
    profileNC.tabBarItem.title = @"Профиль";
    
    self.tabController = [[UITabBarController alloc] init];
    self.tabController.viewControllers = @[companionsNC, profileNC];
    
    [self presentViewController:self.tabController
                       animated:YES
                     completion:nil];
}

@end
