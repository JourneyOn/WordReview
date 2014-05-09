//
//  WRWord.m
//  WordReview
//
//  Created by shupeng on 5/9/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "WRWord.h"

@implementation WRWord
@dynamic user;
@dynamic word;
@dynamic source;
@dynamic image;

+ (NSString *)parseClassName
{
    return NSStringFromClass(self);
}


@end
