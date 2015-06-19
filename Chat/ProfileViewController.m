//
//  ProfileViewController.m
//  Chat
//
//  Created by almakaev iliyas on 17.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "ProfileViewController.h"
#import <Quickblox/Quickblox.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Профиль";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Выйти" style:UIBarButtonItemStyleDone target:self action:@selector(exitProfile)];
    

    
}

- (void)exitProfile
{
    
}


@end
