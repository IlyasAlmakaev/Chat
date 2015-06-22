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

@interface LoginViewController () <QBChatDelegate>

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
    // Create session with user
  /*  NSString *userLogin = self.loginField.text;
    NSString *userPassword = self.passwordField.text;
    
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = userLogin;
    parameters.userPassword = userPassword;
    
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
        // Sign In to QuickBlox Chat
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID; // your current user's ID
        currentUser.password = userPassword; // your current user's password
        
        // set Chat delegate
        [[QBChat instance] addDelegate:self];
        
        // login to Chat
        [[QBChat instance] loginWithUser:currentUser];
        
        [self enterProfile];
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"error: %@", response.error);
    }];*/
    
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
    CopmanionsTableViewController *companionsVC = [[CopmanionsTableViewController alloc] init];
//    UINavigationController *companionsNC = [[UINavigationController alloc] initWithRootViewController:companionsVC];
 //   companionsVC.tabBarItem.title = @"Собеседники";
    
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    UINavigationController *profileNC = [[UINavigationController alloc] initWithRootViewController:profileVC];
    profileNC.tabBarItem.title = @"Профиль";
    
    /*   self.tabController = [[UITabBarController alloc] init];
    self.tabController.viewControllers = @[companionsVC, profileNC];*/
    
    [self presentViewController:companionsVC
                       animated:YES
                     completion:nil];
}

@end
