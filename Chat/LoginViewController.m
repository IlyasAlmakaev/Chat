//
//  LoginViewController.m
//  Chat
//
//  Created by almakaev iliyas on 16.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

- (IBAction)registration:(id)sender;

@property (strong, nonatomic) RegisterViewController *registerVC;
@property (strong, nonatomic) UINavigationController *navigationC;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Вход";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Войти" style:UIBarButtonItemStyleDone target:self action:@selector(enter)];
}

- (IBAction)registration:(id)sender
{
    self.registerVC = [[RegisterViewController alloc] init];
    
    self.navigationC = [[UINavigationController alloc] initWithRootViewController:self.registerVC];
    [self presentViewController:self.navigationC animated:YES completion:nil];
}

- (void)enter
{
    
}

@end
