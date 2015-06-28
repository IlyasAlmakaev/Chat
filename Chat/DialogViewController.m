//
//  DialogViewController.m
//  Chat
//
//  Created by almakaev iliyas on 24.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "DialogViewController.h"
#import "ChatTableViewCell.h"
#import "ChatService.h"

@interface DialogViewController () <UITableViewDelegate, UITableViewDataSource, ChatServiceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tView;
@property (weak, nonatomic) IBOutlet UITextField *sendField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendAction:(id)sender;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableDictionary *messages;
@property (nonatomic, strong) NSMutableArray *messageContent;
@property (nonatomic, strong) QBChatMessage *messageSend;

@property (nonatomic, strong) UIImage *orangeBubble;
@property (nonatomic, strong) UIImage *aquaBubble;

@end

@implementation DialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(back)];   
    self.tView.delegate = self;
    self.tView.dataSource = self;
    
    self.tView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getPreviousMessages)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Set keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [ChatService shared].delegate = self;
    
    // Set title
    if(self.dialogUsers.type == QBChatDialogTypePrivate){
        QBUUser *recipient = [ChatService shared].usersAsDictionary[@(self.dialogUsers.recipientID)];
        self.title = recipient.login == nil ? recipient.email : recipient.login;
    }else{
        self.title = self.dialogUsers.name;
    }
    
    // sync messages history
    //
    [self syncMessages:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [ChatService shared].delegate = nil;
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (void)getPreviousMessages{
    
    // load more messages here
    //
    [self syncMessages:YES];
}

#pragma mark
#pragma mark UITextFieldDelegate

// Hide Keyboard/DateBoard/RepeatOptions
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

- (void) hideKeyboard
{
    [self.view endEditing:YES];
}


#pragma mark
#pragma mark Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
        self.sendField.transform = CGAffineTransformMakeTranslation(0, -250);
        self.sendButton.transform = CGAffineTransformMakeTranslation(0, -250);
        self.tView.frame = CGRectMake(self.tView.frame.origin.x,
                                      self.tView.frame.origin.y,
                                      self.tView.frame.size.width,
                                      self.tView.frame.size.height-252);
    }];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
        self.sendField.transform = CGAffineTransformIdentity;
        self.sendButton.transform = CGAffineTransformIdentity;
        self.tView.frame = CGRectMake(self.tView.frame.origin.x,
                                      self.tView.frame.origin.y,
                                      self.tView.frame.size.width,
                                      self.tView.frame.size.height+252);
    }];
}

#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ChatService shared] messagsForDialogId:self.dialogUsers.ID] count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ChatMessageCellIdentifier = @"ChatMessageCellIdentifier";
    
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatMessageCellIdentifier];
    if(cell == nil){
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatMessageCellIdentifier];
    }
    
    QBChatMessage *message = [[ChatService shared] messagsForDialogId:self.dialogUsers.ID][indexPath.row];
    //
    [cell configureCellWithMessage:message];
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QBChatMessage *chatMessage = [[[ChatService shared] messagsForDialogId:self.dialogUsers.ID] objectAtIndex:indexPath.row];
    CGFloat cellHeight = [ChatTableViewCell heightForCellWithMessage:chatMessage];
    return cellHeight;
}

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}*/

/*- (NSMutableArray *)messagsForDialogId:(NSString *)dialogId
{
    NSMutableArray *messages = [self.messages objectForKey:dialogId];
    NSLog(@"test mutable array %@", messages);
    if(messages == nil){
        messages = [NSMutableArray array];
        [self.messages setObject:messages forKey:dialogId];
    }
    
    return messages;
}*/

// Exit
- (void)back
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendAction:(id)sender
{
    NSString *messageText = self.sendField.text;
    if(messageText.length == 0)
    {
        return;
    }
    
    // send a message
    BOOL sent = [[ChatService shared] sendMessage:messageText toDialog:self.dialogUsers];
    if(!sent)
    {
        NSLog(@"Error in internet connection");
        return;
    }
    
    // reload table
    [self.tView reloadData];
    if([[ChatService shared] messagsForDialogId:self.dialogUsers.ID].count > 0)
    {
        [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[ChatService shared] messagsForDialogId:self.dialogUsers.ID] count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    // clean text field
    [self.sendField setText:nil];
}

- (void)syncMessages:(BOOL)loadPrevious
{
    NSArray *messages = [[ChatService shared] messagsForDialogId:self.dialogUsers.ID];
    NSDate *lastMessageDateSent = nil;
    NSDate *firstMessageDateSent = nil;
    if(messages.count > 0)
    {
        lastMessageDateSent = ((QBChatMessage *)[messages lastObject]).dateSent;
        firstMessageDateSent = ((QBChatMessage *)[messages firstObject]).dateSent;
    }
    
    __weak __typeof(self)weakSelf = self;
    
    NSMutableDictionary *extendedRequest = [[NSMutableDictionary alloc] init];
    if(loadPrevious){
        if(firstMessageDateSent != nil)
        {
            extendedRequest[@"date_sent[lte]"] = @([firstMessageDateSent timeIntervalSince1970]-1);
        }
    }else{
        if(lastMessageDateSent != nil)
        {
            extendedRequest[@"date_sent[gte]"] = @([lastMessageDateSent timeIntervalSince1970]+1);
        }
    }
    extendedRequest[@"sort_desc"] = @"date_sent";
    
    QBResponsePage *page = [QBResponsePage responsePageWithLimit:100 skip:0];
    [QBRequest messagesWithDialogID:self.dialogUsers.ID
                    extendedRequest:extendedRequest
                            forPage:page
                       successBlock:^(QBResponse *response, NSArray *messages, QBResponsePage *page)
    {
                           if(messages.count > 0)
                           {
                               [[ChatService shared] addMessages:messages forDialogId:self.dialogUsers.ID];
                           }
                           
                           if(loadPrevious)
                           {
                               NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                               [formatter setDateFormat:@"MMM d, h:mm a"];
                               NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
                               NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                                           forKey:NSForegroundColorAttributeName];
                               NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
                               weakSelf.refreshControl.attributedTitle = attributedTitle;
                               
                               [weakSelf.refreshControl endRefreshing];
                               
                               [weakSelf.tView reloadData];
                           }else{
                               [weakSelf.tView reloadData];
                               NSInteger count = [[ChatService shared] messagsForDialogId:self.dialogUsers.ID].count;
                               if(count > 0){
                                   [weakSelf.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count-1 inSection:0]
                                                                     atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                               }
                           }
                       } errorBlock:^(QBResponse *response) {
                           
                       }];
}


#pragma mark
#pragma mark ChatServiceDelegate

- (void)chatDidLogin
{
    // sync messages history
    //
    [self syncMessages:NO];
}

- (BOOL)chatDidReceiveMessage:(QBChatMessage *)message
{
    NSString *dialogId = message.dialogID;
    if(![self.dialogUsers.ID isEqualToString:dialogId]){
        return NO;
    }
    
    // Reload table
    [self.tView reloadData];
    if([[ChatService shared] messagsForDialogId:self.dialogUsers.ID].count > 0){
        [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[ChatService shared] messagsForDialogId:self.dialogUsers.ID] count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    return YES;
}


@end
