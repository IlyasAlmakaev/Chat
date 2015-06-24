//
//  CompanionsViewController.h
//  Chat
//
//  Created by almakaev iliyas on 19.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface CompanionsViewController : UIViewController

@property (nonatomic, strong) NSString *userLogin;
@property (nonatomic, strong) NSString *userPassword;

@property (strong, nonatomic) QBChatDialog *createdDialog;

@end
