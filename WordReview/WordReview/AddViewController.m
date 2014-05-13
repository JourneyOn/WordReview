//
//  AddViewController.m
//  WordReview
//
//  Created by shupeng on 5/8/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "AddViewController.h"
#import "PlaceholderTextView.h"
#import "ImageCropperViewController.h"

#import "WRWord.h"
#import "WRUser.h"

@interface AddViewController () <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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
    [_descriptionTextView setPlaceholder:@"The original source"];
    
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
    WRUser *currentUser = [WRUser currentUser];
    
    WRWord *word = [WRWord new];
    word.user =  currentUser;
    word.word = _wordTextField.text;
    word.source = _descriptionTextView.text;
    if (_imageView.image) {
        AVFile *image = [AVFile fileWithData:UIImagePNGRepresentation(_imageView.image)];
        word.image = image;
    }
    
    [SVProgressHUD showWithStatus:@"saving..."];
    [word saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [currentUser.words addObject:word];

            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [SVProgressHUD showSuccessWithStatus:@"Success!"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else{
                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                }
            }];
        }
        else{
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }
    }];
    
}

- (void)keyboardDoneBtnPressed:(id)sender
{
    [_descriptionTextView resignFirstResponder];
}

- (IBAction)imageViewTapped:(UITapGestureRecognizer *)sender {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Camera",@"From User Lib", nil];
    [as showInView:self.view];
}

#pragma mark - Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *vc = [[UIImagePickerController alloc] init];
            vc.delegate = self;
            vc.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:vc animated:YES completion:nil];
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"Camera Not Available!"];
        }
    }
    else if (buttonIndex == 1) {
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController *vc = [[UIImagePickerController alloc] init];
            vc.delegate = self;
            vc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            [self presentViewController:vc animated:YES completion:nil];
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"Photo Lib Not Available!"];
        }
    }
    else if (buttonIndex == 2) {
        
    }
}

#pragma mark - Image Pick Controller Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0);
{
    ImageCropperViewController *targetVC = [[ImageCropperViewController alloc] initWithNibName:NSStringFromClass([ImageCropperViewController class]) bundle:nil];
    [picker.navigationController pushViewController:targetVC animated:YES];
}
@end
