//
//  CompanionsViewController.m
//  Chat
//
//  Created by almakaev iliyas on 19.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "CompanionsViewController.h"
#import "CompanionsTableViewCell.h"
#import <Quickblox/Quickblox.h>

@interface CompanionsViewController () <UITableViewDelegate, UITableViewDataSource, QBChatDelegate>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSMutableArray *userContacts;

- (IBAction)addCompanion:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *companionField;
@property (weak, nonatomic) IBOutlet UITableView *tView;

@end

@implementation CompanionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
/*    self.navigationItem.title = @"Собеседники";
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(add)];*/
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = self.userLogin;
    parameters.userPassword = self.userPassword;
    
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
        // Sign In to QuickBlox Chat
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID; // your current user's ID
        currentUser.password = self.userPassword; // your current user's password
        
        // set Chat delegate
        [[QBChat instance] addDelegate:self];
        
        // login to Chat
        [[QBChat instance] loginWithUser:currentUser];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"error: %@", response.error);
    }];
    
    self.users = [NSArray array];
    self.userContacts = [NSMutableArray array];
    
    self.tView.delegate = self;
    self.tView.dataSource = self;
    [self.tView registerNib:[UINib nibWithNibName:@"CompanionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"id"];
}

#pragma mark -
#pragma mark QBChatDelegate

- (void)chatDidReceiveContactAddRequestFromUser:(NSUInteger)userID{
    // do something
    NSLog(@"Request from user ID = %zd", userID);
    [[QBChat instance] confirmAddContactRequest:userID];
}

- (void)chatContactListDidChange:(QBContactList *)contactList{
    //  [[NSNotificationCenter defaultCenter] postNotificationName:ContactListChanged object:nil];
    NSLog(@"contact list changed");
    NSLog(@"current contact list %@", [QBChat instance].contactList.contacts);
    //    self.userContacts = [QBChat instance].contactList.contacts;
    [self retrieveUsers];
}

-(void) chatDidLogin
{
    // You have successfully signed in to QuickBlox Chat
    //    [[QBChat instance] addUserToContactListRequest:3740050];
    NSLog(@"ContactList = %@",[QBChat instance].contactList);
    NSLog(@"Proverka");
}

- (void)chatDidNotLoginWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 //   CompanionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id" forIndexPath:indexPath];
//    CompanionsTableViewCell* cell = [self.tView dequeueReusableCellWithIdentifier:@"id"];
    CompanionsTableViewCell *cell = (CompanionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"id"];
    
    QBUUser *user = (self.users)[[indexPath row]];
    NSLog(@"Test user load = %@", user.login);
    cell.nameUser.text = user.login;
    
    // Configure the cell...
    
    return cell;
}

- (void)add
{

}

// Retrieve QuickBlox Users
- (void)retrieveUsers
{
/*    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [QBRequest usersForPage:[QBGeneralResponsePage responsePageWithCurrentPage:0 perPage:100] successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *arrayOfUsers) {

        self.users = arrayOfUsers;
        [self.tView reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        QBUUser *user;
    //    NSLog(@"User = %@", user.login);
    } errorBlock:^(QBResponse *response) {
        NSLog(@"Errors = %@", response.error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];*/
    
    NSLog(@"Array of user Contacts = %@", [QBChat instance].contactList.contacts);
    
    for (QBContactListItem * contact in [QBChat instance].contactList.contacts)
    {
        NSString * userIDString = [NSString stringWithFormat:@"%ld", (unsigned long)contact.userID];
        
        [self.userContacts addObject:userIDString];
        NSLog(@"ID Array = %@", self.userContacts);
    }
    
    if (self.userContacts == nil)
        return;
    else
    {
        [QBRequest usersWithIDs:self.userContacts page:[QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:10] successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
            // Successful response with page information and users array
            NSLog(@"User contacts for tableView = %@", users);
            self.users = users;
            [self.tView reloadData];
        } errorBlock:^(QBResponse *response) {
            // Handle error here
        }];
    }
    
}

- (IBAction)addCompanion:(id)sender
{
 //   [[QBChat instance] addUserToContactListRequest:3669851];
 //   [[QBChat instance] confirmAddContactRequest:3669851];
 //   QBUUser *user;
  //  NSLog(@"%@", user.login);
    [self retrieveUsers];
   
  //  [self.companionField.text intValue]
}
@end
