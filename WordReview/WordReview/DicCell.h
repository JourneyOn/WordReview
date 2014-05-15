//
//  DicCell.h
//  WordReview
//
//  Created by shupeng on 5/15/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRWordDic.h"

@interface DicCell : UITableViewCell

+ (CGFloat)heightForDicEntry:(NSDictionary *)dicEntry;

- (void)configWithDicEntry:(NSDictionary *)dicEntry;
@end
