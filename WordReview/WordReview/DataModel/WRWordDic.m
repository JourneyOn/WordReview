//
//  WRWordDic.m
//  WordReview
//
//  Created by shupeng on 5/13/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "WRWordDic.h"
#import "DataModelManager.h"

@implementation WRWordDic
@dynamic word;
@dynamic englishPronounce;
@dynamic americaPronounce;
@dynamic englishPronounceVoiceData;
@dynamic americaPronouceVoiceData;

@dynamic collinsPronounce;
@dynamic entries;

+ (NSString *)parseClassName
{
    return NSStringFromClass(self);
}
@end
