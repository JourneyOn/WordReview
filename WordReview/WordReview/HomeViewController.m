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

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, AddViewControllerDelegate>
{
    UIActivityIndicatorView *_refreshIndicator;
    UITableView *_tableView;
    
    NSInteger _refreshState;                    // 0: no, 1: yes
    NSInteger _addWordState;                    // 0: no, 1: yes
    NSMutableArray *_wordsCopy;
}
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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addBtnPressed:)];
    _refreshIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithCustomView:_refreshIndicator];
    self.navigationItem.leftBarButtonItem = addBtn;
    self.navigationItem.rightBarButtonItem = refreshBtn;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEW_BEGIN_Y + 44, SCREEN_WIDTH, SCREEN_HEIGHT - VIEW_BEGIN_Y - 44 - 44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, -480, SCREEN_WIDTH, 480)];
    tipView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 420, SCREEN_WIDTH, 60)];
    label.text = @"**  持之以恒  **";
    label.textColor = [UIColor blueColor];
    label.font = [UIFont systemFontOfSize:24];
    label.textAlignment = NSTextAlignmentCenter;
    [tipView addSubview:label];
    [_tableView addSubview:tipView];
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
    
    [self doRefresh];
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

- (void)doRefresh
{
    if (_addWordState) {
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        _addWordState = 0;
    }
    else{
        if (_wordsCopy == nil) {
            [self doRefreshFromServer];
        }else{
            
        }
    }
}

- (void)doRefreshFromServer
{
    if (_refreshState == 0) {

        
        WRUser *user = [WRUser currentUser];
        AVRelation *allWords = user.words;
        
        if (allWords) {
            _refreshIndicator.hidden = NO;
            [_refreshIndicator startAnimating];
            _refreshState = 1;

            [[allWords query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                _refreshState = 0;
                [_refreshIndicator stopAnimating];
                _refreshIndicator.hidden = YES;
                if (error) {
//                    [SVProgressHUD showErrorWithStatus:@"Sync Error!"];
                }
                else{
                    _wordsCopy = [NSMutableArray arrayWithArray:objects];
                    [_tableView reloadData];
                }
            }];
        }

        

    }

}

#pragma mark - Local Interaction
- (void)addBtnPressed:(UIBarButtonItem *)sender
{
    AddViewController *addVC = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
    addVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addVC];
    [self.navigationController.tabBarController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Add VC delegate
- (void)addViewController:(AddViewController *)vc didSaveWord:(WRWord *)word
{
    if (_wordsCopy == nil) {
        _wordsCopy = [NSMutableArray array];
    }
    [_wordsCopy insertObject:word atIndex:0];
    _addWordState = 1;
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [_wordsCopy count];
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.imageView.frameWidth = 45;
        cell.imageView.frameHeight = 45;
    }
    
    WRWord *word = [_wordsCopy objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithData:[word.image getData]];
    cell.textLabel.text = word.word;
    cell.detailTextLabel.text = word.source;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRWord *word = [_wordsCopy objectAtIndex:indexPath.row];
    [_wordsCopy removeObjectAtIndex:indexPath.row];
    
    WRUser *user = [WRUser currentUser];
    AVRelation *allWords = [user words];
    [word deleteEventually];
    [allWords removeObject:word];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
