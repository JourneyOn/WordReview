//
//  ImageCropperView.h
//
//
//  Created by Shu Peng on 13-12-31.
//  Copyright (c) 2013年 Shu Peng All rights reserved.
//  John.iHello@qq.com
//

#import <UIKit/UIKit.h>

@interface ImageCropperView : UIView

- (void)setImage:(UIImage *)image;
- (void)rotateClockWise90Degree;
- (UIImage *)cropImage;
@end
