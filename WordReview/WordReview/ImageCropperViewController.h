//
//  ImageCropperViewController.h
//  WordReview
//
//  Created by shupeng on 5/9/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageCropperViewController : UIViewController

- (void)setImage:(UIImage *)image completeBlock:(void (^)(UIImage *image))block;
@end
