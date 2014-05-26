//
//  DicViewController.m
//  WordReview
//
//  Created by shupeng on 5/15/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "DicViewController.h"
#import "DicCell.h"

#import "DataModelManager.h"
#import "DicParser.h"

@interface DicViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSString *_word;
    WRWordDic *_wordDic;
    
    UITableView *_tableView;
    UIActivityIndicatorView *_indicatorView;
}
@end

@implementation DicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithWord:(NSString *)word
{
    self = [super init];
    if (self) {
        _word = word;
    }
    return self;
}

- (void)setWordDic:(WRWordDic *)wordDic
{
    _wordDic = wordDic;
}

- (void)loadView
{
    [super loadView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = _word;
    
    // tableview
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEW_BEGIN_Y + 44, SCREEN_WIDTH, SCREEN_HEIGHT - VIEW_BEGIN_Y - 44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.allowsSelection = NO;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [_tableView registerClass:[DicCell class] forCellReuseIdentifier:NSStringFromClass([DicCell class])];
    [self.view addSubview:_tableView];
    
    // table header view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UILabel *wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, 310, 30)];
    [wordLabel setFont:[UIFont systemFontOfSize:28]];
    [headerView addSubview:wordLabel];
    
    // indicator
    if (_wordDic == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = CGPointMake(self.view.frameWidth/2, VIEW_BEGIN_Y + 44 + (self.view.frameHeight -  VIEW_BEGIN_Y - 44)/2);
        [self.view addSubview:_indicatorView];
        [_indicatorView startAnimating];
    }
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
    if (_wordDic == nil) {
        [self fetchDicBackground:_word];
    }
}

- (void)fetchDicBackground:(NSString *)word
{
    NSString *urlStr = [NSString stringWithFormat:[[DataModelManager sharedInstance] getServerByKey:SERVER_YOUDAO_COLLINS], word];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _wordDic = [WRWordDic wordDicWithYouDaoDic:responseObject];
        
        [_indicatorView stopAnimating];
        [_indicatorView removeFromSuperview];
        [_tableView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(dicViewControllerDidLoadDic:)]) {
            [self.delegate dicViewControllerDidLoadDic:_wordDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Get Dic. Error!"];
    }];
}


#pragma makr - TabelView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicEntry = [_wordDic.entries objectAtIndex:indexPath.row];
    
    return [DicCell heightForDicEntry:dicEntry];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _wordDic.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DicCell class])];
    
//    if (indexPath.row%2 == 0) {
//        cell.backgroundColor = [UIColor lightGrayColor];
//    }
//    else{
//        cell.backgroundColor = [UIColor whiteColor];
//    }
    
    NSDictionary *dicEntry = [_wordDic.entries objectAtIndex:indexPath.row];
    [cell configWithDicEntry:dicEntry];
    
    
    
    
    return cell;
}

@end
