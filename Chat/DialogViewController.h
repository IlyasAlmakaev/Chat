//
//  DialogViewController.h
//  Chat
//
//  Created by almakaev iliyas on 24.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface DialogViewController : UIViewController

@property (nonatomic, strong) QBChatDialog *dialog;

@end
