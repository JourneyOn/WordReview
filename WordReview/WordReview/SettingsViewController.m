//
//  SettingsViewController.m
//  WordReview
//
//  Created by shupeng on 5/7/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "SettingsViewController.h"
#import "WRUser.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation SettingsViewController

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
    
    self.title = @"Settings";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEW_BEGIN_Y + 44, SCREEN_WIDTH, SCREEN_HEIGHT - VIEW_BEGIN_Y - 44) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(20,10, 280, 44)];
    logoutBtn.layer.masksToBounds = YES;
    logoutBtn.layer.cornerRadius = 8.f;
    [logoutBtn setBackgroundColor:[UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1]];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    [logoutBtn setTitle:@"Log  out" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [logoutBtn addTarget:self action:@selector(logoutBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:logoutBtn];
    _tableView.tableFooterView = footView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - Local interaction
- (void)logoutBtnPressed:(UIButton *)sender
{
    [WRUser logOut];
    [self.navigationController.tabBarController setSelectedIndex:0];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {

        }
    }
    
    return cell;
}
@end
