//
//  DicViewController.h
//  WordReview
//
//  Created by shupeng on 5/15/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRWordDic.h"

@protocol DicViewControllerDelegate <NSObject>
@optional
- (void)dicViewControllerDidLoadDic:(WRWordDic *)wordDic;

@end



@interface DicViewController : UIViewController
@property (weak, nonatomic) id <DicViewControllerDelegate> delegate;

- (id)initWithWord:(NSString *)word;
- (void)setWordDic:(WRWordDic *)wordDic;
@end
