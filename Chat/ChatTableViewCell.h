//
//  ChatTableViewCell.h
//  Chat
//
//  Created by intent on 28/06/15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
#import "ChatService.h"

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextView  *messageTextView;
@property (nonatomic, strong) UILabel     *nameAndDateLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;

+ (CGFloat)heightForCellWithMessage:(QBChatMessage *)message;
- (void)configureCellWithMessage:(QBChatMessage *)message;

@end
