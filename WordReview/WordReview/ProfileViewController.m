//
//  ProfileViewController.m
//  WordReview
//
//  Created by shupeng on 5/4/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "ProfileViewController.h"
#import "SettingsViewController.h"

@interface ProfileViewController ()
{
    
}
@end

@implementation ProfileViewController

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
    
    UIBarButtonItem *setttingBtn = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingBtnPressed:)];
    self.navigationItem.rightBarButtonItem = setttingBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma makr - Local Interaction
- (void)settingBtnPressed:(UIBarButtonItem *)sender
{
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

@end
