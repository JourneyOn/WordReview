//
//  DicParser.h
//  WordReview
//
//  Created by shupeng on 5/13/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WRWordDic.h"

@interface DicParser : NSObject

@end




@interface  WRWordDic (YouDaoParse)
+ (WRWordDic *)wordDicWithYouDaoJson:(NSString *)json;
+ (WRWordDic *)wordDicWithYouDaoDic:(NSDictionary *)dic;
@end

@interface NSString (WordProcess)
- (NSString *)trimedForWord;
- (NSString *)trimHtmlTag;
@end