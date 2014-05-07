//
//  LoginViewController.m
//  WordReview
//
//  Created by shupeng on 5/7/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "WRUser.h"

@interface LoginViewController () <UITextFieldDelegate, UIAlertViewDelegate>
{
    UITextField *_userName;
    UITextField *_email;
    UITextField *_password;
}
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Log in";
    
    UIBarButtonItem *signUpBtn = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStylePlain target:self action:@selector(signUpBtnPressed:)];
    self.navigationItem.rightBarButtonItem = signUpBtn;
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(20, VIEW_BEGIN_Y + NAV_HEIGHT + 10, SCREEN_WIDTH -  20*2, 30)];
    _userName.returnKeyType = UIReturnKeyNext;
    _userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userName.autocorrectionType = UITextAutocorrectionTypeNo;
    _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userName.borderStyle = UITextBorderStyleRoundedRect;
    _userName.placeholder = @"Name";
    _userName.delegate = self;
    [self.view addSubview:_userName];

    /*
    _email = [[UITextField alloc] initWithFrame:CGRectMake(20, VIEW_BEGIN_Y + NAV_HEIGHT + 10 + _userName.frameHeight + 10, SCREEN_WIDTH - 20 * 2, 30)];
    _email.returnKeyType = UIReturnKeyNext;
    _email.keyboardType = UIKeyboardTypeEmailAddress;
    _email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _email.autocorrectionType = UITextAutocorrectionTypeNo;
    _email.clearButtonMode = UITextFieldViewModeWhileEditing;
    _email.borderStyle = UITextBorderStyleRoundedRect;
    _email.placeholder = @"Email";
    _email.delegate = self;
    [self.view addSubview:_email];
    */
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(20, VIEW_BEGIN_Y + NAV_HEIGHT + 10 + _userName.frameHeight + 10, SCREEN_WIDTH - 20 * 2, 30)];
    _password.secureTextEntry = YES;
    _password.returnKeyType = UIReturnKeyDone;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.borderStyle = UITextBorderStyleRoundedRect;
    _password.placeholder = @"Password";
    _password.delegate = self;
    [self.view addSubview:_password];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _password.frameY + _password.frameHeight + 10, 280, 44)];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 8.f;
    [loginBtn setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.8 alpha:1]];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [loginBtn setTitle:@"Log  in" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(loginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
    UIButton *forgotBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, loginBtn.frameY + loginBtn.frameHeight + 10, 180, 26)];
    [forgotBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Forgot password?" attributes:@{NSUnderlineStyleAttributeName: @1, NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor blueColor]}] forState:UIControlStateNormal];
    [forgotBtn addTarget:self action:@selector(forgotBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [forgotBtn sizeToFit];
    [self.view addSubview:forgotBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login
{
    [SVProgressHUD showWithStatus:@"Log in..."];
    if (!_userName.text.length || !_password.text.length) {
        [SVProgressHUD showErrorWithStatus:@"Empty input"];
    }
    else{
        [WRUser logInWithUsernameInBackground:[_userName.text lowercaseString] password:_password.text block:^(AVUser *user, NSError *error) {
            if (user) {
                [SVProgressHUD dismiss];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }];
    }
}
#pragma mark - Local Interaction
- (void)signUpBtnPressed:(UIBarButtonItem *)sender
{
    SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

- (void)loginBtnPressed:(UIButton *)sender
{
    [self login];
}

- (void)forgotBtnPressed:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reset Password" message:@"input your emal address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confrim", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userName) {
        [_password becomeFirstResponder];
    }
    else if (textField == _password) {
        [self login];
    }
    
    return YES;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [WRUser requestPasswordResetForEmailInBackground:[alertView textFieldAtIndex:0].text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SVProgressHUD showSuccessWithStatus:@"Please check your email, and reset your password!"];
            }
            else{
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            }
        }];
    }
}
@end
