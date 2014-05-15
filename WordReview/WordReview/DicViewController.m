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
#import "WRWordDic.h"
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
        [self fetchDicBackground:_word];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEW_BEGIN_Y + 44, SCREEN_WIDTH, SCREEN_HEIGHT - VIEW_BEGIN_Y - 44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[DicCell class] forCellReuseIdentifier:NSStringFromClass([DicCell class])];
    [self.view addSubview:_tableView];
    
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.center = CGPointMake(self.view.frameWidth/2, (self.view.frameHeight - VIEW_BEGIN_Y - 44)/2);
    [self.view addSubview:_indicatorView];
    [_indicatorView startAnimating];
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
    NSDictionary *dicEntry = [_wordDic.entries objectAtIndex:indexPath.row];
    [cell configWithDicEntry:dicEntry];
    
    return cell;
}

@end
