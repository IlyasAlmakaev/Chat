//
//  LoginViewController.m
//  Chat
//
//  Created by almakaev iliyas on 16.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "CompanionsViewController.h"
#import "CopmanionsTableViewController.h"
#import <Quickblox/Quickblox.h>

@interface LoginViewController ()

- (IBAction)registration:(id)sender;
- (IBAction)logON:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) UITabBarController *tabController;
@property (strong, nonatomic) CopmanionsTableViewController *companionsTVC;
@property (strong, nonatomic) CompanionsViewController *companionsVC;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.companionsTVC = [[CopmanionsTableViewController alloc] init];
    self.companionsVC = [[CompanionsViewController alloc] init];
    
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        NSLog(@"Authorisation");
    } errorBlock:^(QBResponse *response) {
        NSLog(@"%@",[response.error description]);
    }];
}

- (IBAction)registration:(id)sender
{
    // Create QuickBlox User entity
    QBUUser *user = [QBUUser user];
    user.password = self.passwordField.text;
    user.login = self.loginField.text;
    
    [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
        [self enterProfile];

    } errorBlock:^(QBResponse *response) {
        NSLog(@"%@", [response.error description]);
    }];
    
    
}

- (IBAction)logON:(id)sender
{
    
    // Create session with user
    self.companionsVC.userLogin = self.loginField.text;
    self.companionsVC.userPassword = self.passwordField.text;
    
    // Authenticate user
    [QBRequest logInWithUserLogin:self.companionsVC.userLogin password:self.companionsVC.userPassword
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
    
//    UINavigationController *companionsNC = [[UINavigationController alloc] initWithRootViewController:companionsVC];
 //   companionsVC.tabBarItem.title = @"Собеседники";
    
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    UINavigationController *profileNC = [[UINavigationController alloc] initWithRootViewController:profileVC];
    profileNC.tabBarItem.title = @"Профиль";
    
    /*   self.tabController = [[UITabBarController alloc] init];
    self.tabController.viewControllers = @[companionsVC, profileNC];*/
    
    [self presentViewController:self.companionsVC
                       animated:YES
                     completion:nil];}

@end
