//
//  SignUpViewController.m
//  WordReview
//
//  Created by shupeng on 5/7/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "SignUpViewController.h"
#import "WRUser.h"

@interface SignUpViewController () <UITextFieldDelegate>
{
    UITextField *_userName;
    UITextField *_email;
    UITextField *_password;
    UITextField *_passwordConfirm;
}
@end

@implementation SignUpViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Sign Up";
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(20, VIEW_BEGIN_Y + NAV_HEIGHT + 10, SCREEN_WIDTH -  20*2, 30)];
    _userName.returnKeyType = UIReturnKeyNext;
    _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userName.borderStyle = UITextBorderStyleRoundedRect;
    _userName.placeholder = @"Name";
    _userName.delegate = self;
    [self.view addSubview:_userName];
    
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
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(20, VIEW_BEGIN_Y + NAV_HEIGHT + 10 + _userName.frameHeight + 10 + _email.frameHeight + 10, SCREEN_WIDTH - 20 * 2, 30)];
    _password.secureTextEntry = YES;
    _password.returnKeyType = UIReturnKeyDone;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.borderStyle = UITextBorderStyleRoundedRect;
    _password.placeholder = @"Password";
    _password.delegate = self;
    [self.view addSubview:_password];
    
    _passwordConfirm = [[UITextField alloc] initWithFrame:CGRectMake(20, VIEW_BEGIN_Y + NAV_HEIGHT + 10 + _userName.frameHeight + 10 + _email.frameHeight + 10 + _password.frameHeight + 10, SCREEN_WIDTH - 20 * 2, 30)];
    _passwordConfirm.secureTextEntry = YES;
    _passwordConfirm.returnKeyType = UIReturnKeyDone;
    _passwordConfirm.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordConfirm.borderStyle = UITextBorderStyleRoundedRect;
    _passwordConfirm.placeholder = @"Password Confirm";
    _passwordConfirm.delegate = self;
    [self.view addSubview:_passwordConfirm];
    
    UIButton *signUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, _passwordConfirm.frameY + _passwordConfirm.frameHeight + 10, 280, 44)];
    signUpBtn.layer.masksToBounds = YES;
    signUpBtn.layer.cornerRadius = 8.f;
    
    [signUpBtn setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.8 alpha:1]];
    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [signUpBtn setTitle:@"Sign up" forState:UIControlStateNormal];
    [signUpBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [signUpBtn addTarget:self action:@selector(signUpBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)signUp
{
    NSString *name = _userName.text;
    NSString *email = _email.text;
    NSString *password = _password.text;
    NSString *passwordConfrim = _passwordConfirm.text;
    
    if (!name.length || !email.length || !password.length || !passwordConfrim.length) {
        [SVProgressHUD showErrorWithStatus:@"Empty input"];
    }else if (![password isEqualToString:passwordConfrim]) {
        [SVProgressHUD showErrorWithStatus:@"Password not the same"];
    }
    else{
        [SVProgressHUD showWithStatus:@"Sign up..."];
        WRUser *user = [WRUser object];
        user.username = [name lowercaseString];
        user.email = [email lowercaseString];
        user.password = password;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SVProgressHUD showSuccessWithStatus:@"Success!"];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                [WRUser logOut];
            }
        }];
    }
}

#pragma mark - Local Interaction
- (void)signUpBtnPressed:(UIButton *)sender
{
    [self signUp];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userName) {
        [_email becomeFirstResponder];
    }
    else if (textField == _email) {
        [_password becomeFirstResponder];
    }
    else if (textField == _passwordConfirm) {
        [self signUp];
    }
    
    return YES;
}
@end
