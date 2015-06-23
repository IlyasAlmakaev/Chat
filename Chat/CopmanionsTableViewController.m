//
//  CopmanionsTableViewController.m
//  Chat
//
//  Created by almakaev iliyas on 19.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "CopmanionsTableViewController.h"
#import "CompanionsTableViewCell.h"
#import <Quickblox/Quickblox.h>

@interface CopmanionsTableViewController () <QBChatDelegate>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSMutableArray *userContacts;

@end

@implementation CopmanionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.navigationItem.title = @"Собеседники";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(add)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CompanionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"id"];
}

#pragma mark -
#pragma mark QBChatDelegate

- (void)chatDidReceiveContactAddRequestFromUser:(NSUInteger)userID{
    // do something
    NSLog(@"Request from user ID = %zd", userID);
    [[QBChat instance] confirmAddContactRequest:userID];
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
    CompanionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id" forIndexPath:indexPath];
    
    // Configure the cell...
    
    QBUUser *user = (self.users)[[indexPath row]];
    NSLog(@"Test user load = %@", user.login);
    cell.textLabel.text = user.login;
    
    return cell;
}

- (void)chatContactListDidChange:(QBContactList *)contactList{
  //  [[NSNotificationCenter defaultCenter] postNotificationName:ContactListChanged object:nil];
    NSLog(@"contact list changed");
    NSLog(@"current contact list %@", [QBChat instance].contactList.contacts);
//    self.userContacts = [QBChat instance].contactList.contacts;
    [self retrieveUsers];
}

#pragma mark -
#pragma mark QBChatDelegate

// Chat delegate
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

- (void)add
{
    
}

// Retrieve QuickBlox Users
- (void)retrieveUsers
{
 /*   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [QBRequest usersForPage:[QBGeneralResponsePage responsePageWithCurrentPage:0 perPage:100] successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *arrayOfUsers) {
        
        self.users = arrayOfUsers;
        [self.tableView reloadData];
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
        [self.tableView reloadData];
    } errorBlock:^(QBResponse *response) {
        // Handle error here
    }];
}
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
