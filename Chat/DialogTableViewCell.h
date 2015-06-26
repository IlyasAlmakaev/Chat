//
//  DialogTableViewCell.h
//  Chat
//
//  Created by almakaev iliyas on 25.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>


@interface DialogTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameAndDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, readonly) NSMutableDictionary *usersAsDictionary;
+ (CGFloat)heightForCellWithMessage:(QBChatMessage *)message;
- (void)configureCellWithMessage:(QBChatMessage *)message;

@end
