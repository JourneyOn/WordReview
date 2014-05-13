//
//  WRWordDic.h
//  WordReview
//
//  Created by shupeng on 5/13/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

#define ENTRY_DESCRIPTION   @"ENTRY_DESCRIPTION"
#define ENTRY_EXAMPLE       @"ENTRY_EXAMPLE"
#define ENTRY_EXPLAIN       @"ENTRY_EXPLAIN"


@interface WRWordDic : AVObject <AVSubclassing>
@property (nonatomic, retain) NSString *word;
@property (nonatomic, retain) NSString *englishPronounce;
@property (nonatomic, retain) NSString *americaPronounce;
@property (nonatomic, retain) NSData *englishPronounceVoiceData;
@property (nonatomic, retain) NSData *americaPronouceVoiceData;

@property (nonatomic, retain) NSString *collinsPronounce;
@property (nonatomic, retain) NSArray *entries;


@end
