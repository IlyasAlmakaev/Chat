//
//  CompanionsTableViewCell.h
//  Chat
//
//  Created by almakaev iliyas on 19.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanionsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameUser;
@property (weak, nonatomic) IBOutlet UILabel *lastMassageLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imagePerson;

@end
