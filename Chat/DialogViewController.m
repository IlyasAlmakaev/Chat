//
//  DialogViewController.m
//  Chat
//
//  Created by almakaev iliyas on 24.06.15.
//  Copyright (c) 2015 almakaev iliyas. All rights reserved.
//

#import "DialogViewController.h"

@interface DialogViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tView;
@property (weak, nonatomic) IBOutlet UITextField *sendField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendAction:(id)sender;

@end

@implementation DialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(back)];
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


// Exit
- (void)back
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendAction:(id)sender {
}
@end
