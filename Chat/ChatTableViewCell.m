//
//  ChatTableViewCell.m
//  Chat
//
//  Created by intent on 28/06/15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "ChatTableViewCell.h"

#define padding 20

@implementation ChatTableViewCell

static UIImage *orangeBubble;
static UIImage *aquaBubble;

+ (void)initialize{
    [super initialize];
    
    // init bubbles
    orangeBubble = [[UIImage imageNamed:@"orangeBubble"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
    aquaBubble = [[UIImage imageNamed:@"aquaBubble"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
}

+ (CGFloat)heightForCellWithMessage:(QBChatMessage *)message
{
    NSString *text = message.text;
    CGSize  textSize = {260.0, 10000.0};
    
    NSUInteger height;
        CGRect rect = [text boundingRectWithSize:textSize
                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                      attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} context:nil];
        rect.size.height += 45.0;
        height = rect.size.height;

    
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameAndDateLabel = [[UILabel alloc] init];
        [self.nameAndDateLabel setFrame:CGRectMake(10, 5, 300, 20)];
        [self.nameAndDateLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self.nameAndDateLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.nameAndDateLabel];
        
        self.backgroundImageView = [[UIImageView alloc] init];
        [self.backgroundImageView setFrame:CGRectZero];
        [self.contentView addSubview:self.backgroundImageView];
        
        self.messageTextView = [[UITextView alloc] init];
        [self.messageTextView setBackgroundColor:[UIColor clearColor]];
        [self.messageTextView setEditable:NO];
        [self.messageTextView setScrollEnabled:NO];
        [self.messageTextView sizeToFit];
        [self.contentView addSubview:self.messageTextView];
    }
    return self;
}

- (void)configureCellWithMessage:(QBChatMessage *)message
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    
    self.messageTextView.text = message.text;
    
    CGSize textSize = { 260.0, 10000.0 };
    
    NSUInteger width;
    NSUInteger height;
        CGRect rect = [self.messageTextView.text  boundingRectWithSize:textSize
                                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                            attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} context:nil];
        rect.size.width += 10;
        width = rect.size.width;
        height = rect.size.height;
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm dd.MM.yy"];
    NSString *time = [format stringFromDate:message.dateSent];
    
    // Left/Right bubble
    if ([QBSession currentSession].currentUser.ID == message.senderID) {
        [self.messageTextView setFrame:CGRectMake(padding, padding+5, width, height+padding)];
        [self.messageTextView sizeToFit];
        
        [self.backgroundImageView setFrame:CGRectMake(padding/2, padding+5,
                                                      self.messageTextView.frame.size.width+padding/2, self.messageTextView.frame.size.height+5)];
        self.backgroundImageView.image = orangeBubble;
        
        CGRect frame = self.nameAndDateLabel.frame;
        
        frame.origin.x= padding/2;//pass the cordinate which you want
        self.nameAndDateLabel.frame = frame;
        
        self.nameAndDateLabel.textAlignment = NSTextAlignmentLeft;
        self.nameAndDateLabel.text = [NSString stringWithFormat:@"Я, %@", time];
        
    } else {
        [self.messageTextView setFrame:CGRectMake(screenWidth-width-padding/2, padding+5, width, height+padding)];
        [self.messageTextView sizeToFit];
        
        [self.backgroundImageView setFrame:CGRectMake(screenWidth-width-padding/2, padding+5,
                                                      self.messageTextView.frame.size.width+padding/2, self.messageTextView.frame.size.height+5)];
        self.backgroundImageView.image = aquaBubble;
        
        CGRect frame = self.nameAndDateLabel.frame;

        frame.origin.x= screenWidth - self.nameAndDateLabel.frame.size.width - padding/2;//pass the cordinate which you want
        self.nameAndDateLabel.frame = frame;
        
        self.nameAndDateLabel.textAlignment = NSTextAlignmentRight;
        
        QBUUser *sender = [ChatService shared].usersAsDictionary[@(message.senderID)];
        self.nameAndDateLabel.text = [NSString stringWithFormat:@"%@, %@", sender.login == nil ? (sender.fullName == nil ? [NSString stringWithFormat:@"%lu", (unsigned long)sender.ID] : sender.fullName) : sender.login, time];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
