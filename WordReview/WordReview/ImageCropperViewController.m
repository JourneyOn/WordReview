//
//  ImageCropperViewController.m
//  WordReview
//
//  Created by shupeng on 5/9/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "ImageCropperViewController.h"
#import "ImageCropperView.h"

@interface ImageCropperViewController ()
{
    ImageCropperView *_imageCropperView;
    UIImage *_image;
}

@property (nonatomic, copy) void (^completeBlock)(UIImage *image);
@end

@implementation ImageCropperViewController

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
    
    self.title = @"Crop Image";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnPressed:)];
    UIBarButtonItem *pickBtn = [[UIBarButtonItem alloc] initWithTitle:@"Pick" style:UIBarButtonItemStylePlain target:self action:@selector(pickBtnPressed:)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    self.navigationItem.rightBarButtonItem = pickBtn;
    
    _imageCropperView = [[ImageCropperView alloc] initWithFrame:self.view.bounds];
    [_imageCropperView setImage:_image];
    [self.view addSubview:_imageCropperView];
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

- (void)setImage:(UIImage *)image completeBlock:(void (^)(UIImage *))block
{
    _image = image;
    self.completeBlock = block;
}

- (void)cancelBtnPressed:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickBtnPressed:(UIBarButtonItem *)sender
{
    UIImage *image = [_imageCropperView cropImage];
    if (self.completeBlock) {
        self.completeBlock(image);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
