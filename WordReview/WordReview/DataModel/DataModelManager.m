//
//  DataModelManager.m
//  WordReview
//
//  Created by shupeng on 5/7/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "DataModelManager.h"
#import "WRUser.h"
#import "WRWord.h"
#import "WRWordDic.h"

#define APP_ID      @"loob22bkczn4jbu955ly40oyjftm0lpnwt1u2le1q496yp88"
#define APP_KEY     @"9q8dfbph01jnrasna0ek9y7ojn65n5l4yy298ufab5d6bv2s"



static id sharedInstance;
@interface DataModelManager ()
{
    NSDictionary *_serverDic;
}
@end

@implementation DataModelManager
+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _serverDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Server" ofType:@".plist"]];
    }
    return self;
}

- (void)setupAVOSCloudWithLaunchOpltions:(NSDictionary *)option
{
    [self initAVSubClass];
    
    [AVOSCloud setApplicationId:APP_ID clientKey:APP_KEY];
    [AVAnalytics trackAppOpenedWithLaunchOptions:option];
}

- (void)initAVSubClass
{
    [WRUser registerSubclass];
    [WRWord registerSubclass];
    [WRWordDic registerSubclass];
}

- (NSString *)getServerByKey:(NSString *)key
{
    return [_serverDic objectForKey:key];
}
@end
