//
//  ImageCropperView.m
//  
//
//  Created by Shu Peng on 13-12-31.
//  Copyright (c) 2013年 Shu Peng All rights reserved.
//  John.iHello@qq.com
//

#import "ImageCropperView.h"

#define COVER_COLOR [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]
#define LINE_COLOR [UIColor blueColor]

#define CROP_WIDTH      320
#define CROP_HEIGHT     320

@interface ImageCropperView() <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    
    NSInteger _rotateCounter;
    
}
@end

@implementation ImageCropperView

- (id)initWithFrame:(CGRect)frame
{
    NSAssert(frame.size.width >= CROP_WIDTH && frame.size.height >= CROP_HEIGHT, @"frame size must bigger than CROP AREA");
    
    self = [super initWithFrame:frame];
    if (self) {
        _rotateCounter = 0;
        [self configViewHierarchy];
    }
    return self;
}

- (void)configViewHierarchy
{
    self.backgroundColor = [UIColor blackColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((320 - CROP_WIDTH)/2, (self.frameHeight- CROP_HEIGHT)/2, CROP_WIDTH, CROP_HEIGHT)];
    _scrollView.showsHorizontalScrollIndicator = _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.clipsToBounds = NO;
    
    _scrollView.maximumZoomScale = 3.f;
    _scrollView.minimumZoomScale = 1.f;
    [self addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] init];
    
    [_scrollView addSubview:_imageView];
    
    UIView *coverView = [self createCoverView];
    [self addSubview:coverView];
}

#pragma mark - Delegate For ScrollView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (scale > 1) {
        
    }
    else if (scale == 1) {
        
    }
}

- (UIView *)createCoverView
{
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.userInteractionEnabled = NO;
    coverView.backgroundColor = [UIColor clearColor];
    
    UIView *topCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, (self.frameHeight - CROP_HEIGHT)/2 )];
    topCover.backgroundColor = COVER_COLOR;
    [coverView addSubview:topCover];
    
    UIView *bottomCover = [[UIView alloc] initWithFrame:CGRectMake(0, self.frameHeight/2 +  CROP_HEIGHT/2, 320, (self.frameHeight - CROP_HEIGHT)/2)];
    bottomCover.backgroundColor = COVER_COLOR;
    [coverView addSubview:bottomCover];
    
    UIView *leftCover = [[UIView alloc] initWithFrame:CGRectMake(0, topCover.frameHeight, (self.frameWidth - CROP_WIDTH)/2, self.frameHeight - topCover.frameHeight - bottomCover.frameHeight)];
    leftCover.backgroundColor = COVER_COLOR;
    [coverView addSubview:leftCover];
    
    UIView *rightCover = [[UIView alloc] initWithFrame:CGRectMake(leftCover.frameWidth + CROP_WIDTH, topCover.frameHeight, (self.frameWidth - CROP_WIDTH)/2, self.frameHeight - topCover.frameHeight - bottomCover.frameHeight)];
    rightCover.backgroundColor = COVER_COLOR;
    [coverView addSubview:rightCover];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(leftCover.frameWidth, topCover.frameHeight, CROP_WIDTH, 2)];
    topLine.backgroundColor = LINE_COLOR;
    [coverView addSubview:topLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(rightCover.frameX - 2, topCover.frameHeight, 2, CROP_HEIGHT)];
    rightLine.backgroundColor = LINE_COLOR;
    [coverView addSubview:rightLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(leftCover.frameWidth, topCover.frameHeight + CROP_HEIGHT - 2, CROP_WIDTH, 2)];
    bottomLine.backgroundColor = LINE_COLOR;
    [coverView addSubview:bottomLine];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(leftCover.frameWidth, topCover.frameHeight, 2, CROP_HEIGHT)];
    leftLine.backgroundColor = LINE_COLOR;
    [coverView addSubview:leftLine];
    
    return coverView;
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
    [_imageView sizeToFit];
    
    CGFloat width = _imageView.frameWidth;
    CGFloat height = _imageView.frameHeight;
    
    CGFloat minScale = 320 / MIN(width, height);
    _imageView.frameWidth = width * minScale;
    _imageView.frameHeight = height * minScale;
    
    [_scrollView setContentSize:CGSizeMake(_imageView.frameWidth, _imageView.frameHeight)];
    [_scrollView setContentOffset:CGPointMake((_imageView.frameWidth - 320)/2, (_imageView.frameHeight - 320)/2)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"size:%@, offset:%@",[NSValue valueWithCGSize:scrollView.contentSize], [NSValue valueWithCGPoint:scrollView.contentOffset]);
}

- (void)rotateClockWise90Degree
{
    _rotateCounter++;
    [_scrollView setZoomScale:1.f];
    
    CGAffineTransform rotateTranform = CGAffineTransformRotate(_scrollView.transform, M_PI_2);
    [UIView animateWithDuration:.25f animations:^{
        _scrollView.transform = rotateTranform;
    }];
}

- (UIImage *)cropImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320), 1, 1);
    CGRect drawRect = CGRectMake(-_scrollView.contentOffset.x, -_scrollView.contentOffset.y, _scrollView.contentSize.width, _scrollView.contentSize.height);
    [_imageView.image drawInRect:drawRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageOrientation orientation = UIImageOrientationUp;
    switch (_rotateCounter%4) {
        case 0:
            orientation = UIImageOrientationUp;
            break;
        case 1:
            orientation = UIImageOrientationRight;
            break;
        case 2:
            orientation = UIImageOrientationDown;
            break;
        case 3:
            orientation = UIImageOrientationLeft;
            break;
        default:
            break;
    }
    image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:orientation];
    


    UIView *flashView = [[UIView alloc] initWithFrame:_scrollView.frame];
    flashView.backgroundColor = [UIColor whiteColor];
    [self addSubview:flashView];
    
    flashView.alpha = 0.f;
    [UIView animateWithDuration:.2 animations:^{
        flashView.alpha = .5f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            flashView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [flashView removeFromSuperview];
        }];
    }];
    
    
    return image;
}
@end
