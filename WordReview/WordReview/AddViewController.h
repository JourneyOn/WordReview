//
//  AddViewController.h
//  WordReview
//
//  Created by shupeng on 5/8/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRWord.h"

@class AddViewController;
@protocol AddViewControllerDelegate <NSObject>

- (void)addViewController:(AddViewController *)vc didSaveWord:(WRWord *)word;

@end


@interface AddViewController : UIViewController
@property (weak, nonatomic) id<AddViewControllerDelegate> delegate;
@end


