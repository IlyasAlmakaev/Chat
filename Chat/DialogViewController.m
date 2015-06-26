//
//  DialogViewController.m
//  Chat
//
//  Created by almakaev iliyas on 24.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "DialogViewController.h"
#import "DialogTableViewCell.h"

@interface DialogViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tView;
@property (weak, nonatomic) IBOutlet UITextField *sendField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendAction:(id)sender;

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
    [[QBChat instance] addDelegate:self];
    //
    [QBChat instance].autoReconnectEnabled = YES;
    //
    [QBChat instance].streamManagementEnabled = YES;
    [QBChat instance].streamResumptionEnabled = YES;
    
    self.tView.delegate = self;
    self.tView.dataSource = self;
    [self.tView registerNib:[UINib nibWithNibName:@"DialogTableViewCell" bundle:nil] forCellReuseIdentifier:@"id"];
    
    NSLog(@"Проверка %@", self.dialogUsers.ID);
    
    self.orangeBubble = [[UIImage imageNamed:@"orangeBubble"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
    self.aquaBubble = [[UIImage imageNamed:@"aquaBubble"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Set keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DialogTableViewCell *cell = (DialogTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"id"];
    
 //   QBChatMessage *message = [self messagsForDialogId:self.dialogUsers.ID][indexPath.row];
  //  NSLog(@"Send message in chat = %@", message.text);
    //
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm dd.MM.yy"];
    cell.nameAndDateLabel.text = [format stringFromDate:self.messageSend.dateSent];

    cell.messageTextView.text = self.messageSend.text;
    
    cell.backgroundImageView.image = self.orangeBubble;
  //  [cell configureCellWithMessage:message];
    
    return cell;
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QBChatMessage *chatMessage = [[self messagsForDialogId:self.dialogUsers.ID] objectAtIndex:indexPath.row];
    CGFloat cellHeight = [DialogTableViewCell heightForCellWithMessage:chatMessage];
    return cellHeight;
}*/

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

#pragma mark -
#pragma mark QBChatDelegate

- (void)chatDidReceiveMessage:(QBChatMessage *)message{
    
}

- (void)chatDidNotSendMessage:(QBChatMessage *)message error:(NSError *)error{
    
}

- (IBAction)sendAction:(id)sender
{
    self.messageSend = [QBChatMessage message];
    [self.messageSend setText:self.sendField.text];
    //
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    [self.messageSend setCustomParameters:params];
    //
    [self.dialogUsers sendMessage:self.messageSend];
    
    self.messageContent = [self.messages objectForKey:self.dialogUsers.ID];
    NSLog(@"Message test text = %@", self.messageSend);
    
    NSLog(@"message content = %@", self.messageSend.text);
    self.sendField.text = nil;
    [self.tView reloadData];
}



@end
