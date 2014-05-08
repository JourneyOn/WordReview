//
//  AddViewController.m
//  WordReview
//
//  Created by shupeng on 5/8/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "AddViewController.h"
#import "PlaceholderTextView.h"

@interface AddViewController () <UITextFieldDelegate, UITextViewDelegate>
{
    __weak IBOutlet UITextField *_wordTextField;
    __weak IBOutlet PlaceholderTextView *_descriptionTextView;
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_addImageLabel;
}
@end

@implementation AddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"Add New Word";
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnPressed:)];
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBtnPressed:)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    _wordTextField.layer.masksToBounds = YES;
    _wordTextField.layer.cornerRadius = 8.f;
    
    _descriptionTextView.layer.masksToBounds = YES;
    _descriptionTextView.layer.cornerRadius = 12.f;
    [_descriptionTextView setPlaceholder:@"Origin"];
    
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UIBarButtonItem *flexibleBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *keyboardDoneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyboardDoneBtnPressed:)];
    [bar setItems:@[flexibleBtn,keyboardDoneBtn]];
    _descriptionTextView.inputAccessoryView = bar;
    
    _imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _imageView.layer.borderWidth = 2.f;
    _imageView.layer.cornerRadius = 8.f;
    
    [_addImageLabel setAttributedText:[[NSAttributedString alloc] initWithString:@"Add Photo" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17], NSUnderlineStyleAttributeName: @1}]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Local Interaction
- (void)cancelBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardDoneBtnPressed:(id)sender
{
    [_descriptionTextView resignFirstResponder];
}

- (IBAction)imageViewTapped:(UITapGestureRecognizer *)sender {
    
}

#pragma mark - Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
