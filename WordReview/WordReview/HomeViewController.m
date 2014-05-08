//
//  HomeViewController.m
//  WordReview
//
//  Created by shupeng on 5/4/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "HomeViewController.h"
#import "WRUser.h"

#import "LoginViewController.h"
#import "AddViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addBtnPressed:)];
    self.navigationItem.leftBarButtonItem = addBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self checkLoginState];
}

#pragma mark - Local Function
- (void)checkLoginState
{
    WRUser *user = [WRUser currentUser];
    if (user == nil) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
}
#pragma mark - Local Interaction
- (void)addBtnPressed:(UIBarButtonItem *)sender
{
    AddViewController *addVC = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addVC];
    [self.navigationController.tabBarController presentViewController:nav animated:YES completion:nil];
}

@end
