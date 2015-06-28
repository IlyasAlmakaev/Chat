//
//  CompanionsViewController.m
//  Chat
//
//  Created by almakaev iliyas on 19.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "CompanionsViewController.h"
#import "CompanionsTableViewCell.h"
#import "DialogViewController.h"
#import "GroupTableViewController.h"
#import "ChatService.h"
#import "SVProgressHUD.h"

@interface CompanionsViewController () <UITableViewDelegate, UITableViewDataSource, QBChatDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSMutableArray *userContacts;

@property (nonatomic, strong) NSMutableArray *dialogs;

@property NSInteger *contactID;
@property (nonatomic, strong) DialogViewController *dialogVC;
@property (nonatomic, strong) GroupTableViewController *groupTVC;
@property (nonatomic, strong) QBChatDialog *chatinDialog;

- (IBAction)addCompanion:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *companionField;
@property (weak, nonatomic) IBOutlet UIButton *addContactButton;
@property (weak, nonatomic) IBOutlet UITableView *tView;

@end

@implementation CompanionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Собеседники";
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(add)];
    
    self.users = [NSArray array];
    self.userContacts = [NSMutableArray array];
    
    self.dialogs = [NSMutableArray array];
    
    self.companionField.delegate = self;
    self.tView.delegate = self;
    self.tView.dataSource = self;
    [self.tView registerNib:[UINib nibWithNibName:@"CompanionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"id"];
    
 //   UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
 //   [self.tView addGestureRecognizer:gestureRecognizer];
    
    self.dialogVC = [[DialogViewController alloc] init];
    self.groupTVC = [[GroupTableViewController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([QBSession currentSession].currentUser == nil)
    {
        return;
    }
    
    if([ChatService shared].dialogs == nil)
    {
        // get dialogs
        //
        [SVProgressHUD showWithStatus:@"Loading"];
        __weak __typeof(self)weakSelf = self;
        
        [[ChatService shared] requestDialogsWithCompletionBlock:^
        {
            [weakSelf.tView reloadData];
            [SVProgressHUD dismiss];
        }];
    }
    else
    {
        [[ChatService shared] sortDialogs];
        [self.tView reloadData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dialogsUpdatedNotification) name:kNotificationDialogsUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidAccidentallyDisconnectNotification) name:kNotificationChatDidAccidentallyDisconnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupDialogJoinedNotification) name:kNotificationGroupDialogJoined object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    // Set keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark
#pragma mark Notifications

- (void)dialogsUpdatedNotification{
    [self.tView reloadData];
}

- (void)chatDidAccidentallyDisconnectNotification{
    [self.tView reloadData];
}

- (void)groupDialogJoinedNotification{
    [self.tView reloadData];
}

- (void)willEnterForegroundNotification{
    [self.tView reloadData];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Нет"])
    {
        [[QBChat instance] rejectAddContactRequest:(NSUInteger)self.contactID];
        NSLog(@"Не принял контакт с ID %zd", self.contactID);
    }
    else if([title isEqualToString:@"Да"])
    {
        
        [[QBChat instance] confirmAddContactRequest:(NSUInteger)self.contactID];
        NSLog(@"Test id = %zd", self.contactID);
        NSLog(@"Button Да was selected.");
    }
    self.contactID = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[ChatService shared].dialogs count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 //   CompanionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id" forIndexPath:indexPath];
//    CompanionsTableViewCell* cell = [self.tView dequeueReusableCellWithIdentifier:@"id"];
    CompanionsTableViewCell *cell = (CompanionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"id"];
 /*   cell.tag  = indexPath.row;
    QBUUser *user = (self.users)[[indexPath row]];
    NSLog(@"Test user load = %@", user.login);
    cell.nameUser.text = user.login;*/
    
    // Configure the cell...
    QBChatDialog *chatDialog = [ChatService shared].dialogs[indexPath.row];
    cell.tag  = indexPath.row;
    
    switch (chatDialog.type)
    {
        case QBChatDialogTypePrivate:
        {
            cell.lastMassageLabel.text = chatDialog.lastMessageText;
            QBUUser *recipient = [ChatService shared].usersAsDictionary[@(chatDialog.recipientID)];
            cell.nameUser.text = recipient.login;
            cell.imagePerson.image = [UIImage imageNamed:@"privateChatIcon"];
        }
            break;
        case QBChatDialogTypeGroup:
        {
            cell.lastMassageLabel.text = chatDialog.lastMessageText;
            cell.nameUser.text = chatDialog.name;
            cell.imagePerson.image = [UIImage imageNamed:@"GroupChatIcon"];
        }
            break;
   /*     case QBChatDialogTypePublicGroup:
        {
            cell.lastMassageLabel.text = chatDialog.lastMessageText;
            cell.nameUser.text = chatDialog.name;
            cell.imagePerson.image = [UIImage imageNamed:@"GroupChatIcon"];
        }
            break;*/
            
        default:
            break;
    }
    
    // set unread badge
    if(chatDialog.unreadMessagesCount > 0)
    {
        cell.unreadMessageLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)chatDialog.unreadMessagesCount];
        cell.unreadMessageLabel.hidden = NO;
    }
    else
    {
        cell.unreadMessageLabel.hidden = YES;
    }
    
    // set group chat joined status
 /*   UIView *groupChatJoinedStatus =  (UIView *)[cell.contentView viewWithTag:202];
    if(chatDialog.isJoined){
        groupChatJoinedStatus.layer.cornerRadius = 5;
        
        groupChatJoinedStatus.hidden = NO;
    }else{
        groupChatJoinedStatus.hidden = YES;
    }*/
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UINavigationController *profileNC = [[UINavigationController alloc] initWithRootViewController:self.dialogVC];
    profileNC.navigationBar.translucent = NO;
 //   profileNC.tabBarItem.title = @"Имя собеседника";
    
    /*   self.tabController = [[UITabBarController alloc] init];
     self.tabController.viewControllers = @[companionsVC, profileNC];*/
    
    if(self.createdDialog != nil)
    {
        self.dialogVC.dialogUsers = self.createdDialog;
        self.createdDialog = nil;
    }
    else
    {
        
        QBChatDialog *dialog = [ChatService shared].dialogs[[indexPath row]];
        self.dialogVC.dialogUsers = dialog;
        
        [self presentViewController:profileNC
                           animated:YES
                         completion:nil];
   /*     self.chatinDialog = [QBChatDialog new];
        self.chatinDialog.type = QBChatDialogTypePrivate;
        QBUUser *user = (self.users)[[indexPath row]];
        self.chatinDialog.occupantIDs = @[@(user.ID)];
        self.dialogVC.dialogUsers = self.chatinDialog;
        NSLog(@"Chat dialog %@", self.dialogVC.dialogUsers.occupantIDs);
 //       QBChatDialog *dialog = (self.dialogs)[[indexPath row]];
  //      self.dialogVC.dialog = dialog;
        [QBRequest createDialog:self.chatinDialog successBlock:^(QBResponse *response, QBChatDialog *createdDialog) {
            [self presentViewController:profileNC
                               animated:YES
                             completion:nil];
        } errorBlock:^(QBResponse *response) {
            
        }];*/
    }
    NSLog(@"Go to dialogVC %@", self.dialogVC.dialogUsers);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

- (void)add
{
UINavigationController *groupNC = [[UINavigationController alloc] initWithRootViewController:self.groupTVC];
    [self presentViewController:groupNC
                       animated:YES
                     completion:nil];
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
        self.companionField.transform = CGAffineTransformMakeTranslation(0, -250);
        self.addContactButton.transform = CGAffineTransformMakeTranslation(0, -250);
        self.tView.frame = CGRectMake(self.tView.frame.origin.x,
                                                  self.tView.frame.origin.y,
                                                  self.tView.frame.size.width,
                                                  self.tView.frame.size.height-252);
    }];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
        self.companionField.transform = CGAffineTransformIdentity;
        self.addContactButton.transform = CGAffineTransformIdentity;
        self.tView.frame = CGRectMake(self.tView.frame.origin.x,
                                                  self.tView.frame.origin.y,
                                                  self.tView.frame.size.width,
                                                  self.tView.frame.size.height+252);
    }];
}


- (IBAction)addCompanion:(id)sender
{
 //   [[QBChat instance] addUserToContactListRequest:3669851];
 //   [[QBChat instance] confirmAddContactRequest:3669851];
 //   QBUUser *user;
  //  NSLog(@"%@", user.login);
    
    [[QBChat instance] addUserToContactListRequest:[self.companionField.text integerValue]];
    self.companionField.text = nil;
    [self.view endEditing:YES];
   
  //  [self.companionField.text intValue]
}

@end
