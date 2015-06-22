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

@interface CompanionsViewController () <UITableViewDelegate, UITableViewDataSource>




@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) UITableView *tView;

- (IBAction)addCompanion:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *companionField;

@end

@implementation CompanionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
/*    self.navigationItem.title = @"Собеседники";
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(add)];*/
    
  //  [self.tableView registerNib:[UINib nibWithNibName:@"CompanionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"id"];
    self.users = [NSMutableArray array];
    
    self.tView.delegate = self;
    self.tView.dataSource = self;
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [QBRequest usersForPage:[QBGeneralResponsePage responsePageWithCurrentPage:0 perPage:100] successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *arrayOfUsers) {

        self.users = arrayOfUsers;
        [self.tView reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        QBUUser *user;
    //    NSLog(@"User = %@", user.login);
    } errorBlock:^(QBResponse *response) {
        NSLog(@"Errors = %@", response.error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
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
