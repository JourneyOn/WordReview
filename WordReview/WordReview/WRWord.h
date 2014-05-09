//
//  WRWord.h
//  WordReview
//
//  Created by shupeng on 5/9/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "WRUser.h"

@interface WRWord : AVObject <AVSubclassing>

@property (retain, nonatomic) WRUser *user;

@property (retain, nonatomic) NSString  *word;
@property (retain, nonatomic) NSString  *source;
@property (retain, nonatomic) AVFile    *image;
@end
