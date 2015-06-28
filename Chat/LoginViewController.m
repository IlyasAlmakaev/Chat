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
#import <Quickblox/Quickblox.h>
#import "ChatService.h"

@interface LoginViewController ()

- (IBAction)registration:(id)sender;
- (IBAction)logON:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) UITabBarController *tabController;
@property (strong, nonatomic) CompanionsViewController *companionsVC;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.companionsVC = [[CompanionsViewController alloc] init];
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
    // QuickBlox session creation
    QBSessionParameters *extendedAuthRequest = [[QBSessionParameters alloc] init];
    
    extendedAuthRequest.userLogin = self.loginField.text;
    extendedAuthRequest.userPassword = self.passwordField.text;
   
    
    //
    [QBRequest createSessionWithExtendedParameters:extendedAuthRequest successBlock:^(QBResponse *response, QBASession *session) {
        
        // Save current user
        //
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID;

        currentUser.login = self.loginField.text;
        currentUser.password = self.passwordField.text;
        
        // Login to QuickBlox Chat
        //
        [[ChatService shared] loginWithUser:currentUser completionBlock:^{
        }];
        
        [self enterProfile];
        
    } errorBlock:^(QBResponse *response) {
        
        NSString *errorMessage = [[response.error description] stringByReplacingOccurrencesOfString:@"(" withString:@""];
        errorMessage = [errorMessage stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }];
  
}

- (void)enterProfile
{
    
    UINavigationController *companionsNC = [[UINavigationController alloc] initWithRootViewController:self.companionsVC];
    companionsNC.navigationBar.translucent = NO;
 //   companionsVC.tabBarItem.title = @"Собеседники";
    
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    UINavigationController *profileNC = [[UINavigationController alloc] initWithRootViewController:profileVC];
    profileNC.tabBarItem.title = @"Профиль";
    
    /*   self.tabController = [[UITabBarController alloc] init];
    self.tabController.viewControllers = @[companionsVC, profileNC];*/
    
    [self presentViewController:companionsNC
                       animated:YES
                     completion:nil];}

@end
