//
//  CompanionsViewController.m
//  Chat
//
//  Created by almakaev iliyas on 19.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "CompanionsViewController.h"
#import "CompanionsTableViewCell.h"

@interface CompanionsViewController () <UITableViewDelegate, UITableViewDataSource>

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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 //   CompanionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id" forIndexPath:indexPath];
    CompanionsTableViewCell *cell = (CompanionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"id"];
    
    // Configure the cell...
    
    return cell;
}

- (void)add
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
