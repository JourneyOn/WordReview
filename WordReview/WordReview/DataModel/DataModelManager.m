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


#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseQueue.h>

#define APP_ID      @"loob22bkczn4jbu955ly40oyjftm0lpnwt1u2le1q496yp88"
#define APP_KEY     @"9q8dfbph01jnrasna0ek9y7ojn65n5l4yy298ufab5d6bv2s"



static id sharedInstance;
@interface DataModelManager ()
{
    NSDictionary *_serverDic;
    FMDatabaseQueue *_dbQueue;
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



/**********    IMG & DIC DATABASE     **********/
- (void)setupCache
{
    // setup queue
    NSString *dbDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [dbDir stringByAppendingPathComponent:@"user.sqlite"];
    _dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    
    
    // setup table
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"CREATE TABLE IF NOT EXISTS 'IMG' ('img_id' VARCHAR(30) PRIMARY KEY, 'img_path' VARCHAR(30))";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"error when create IMG table");
            }
            
            sql = @"CREATE TABLE IF NOT EXISTS 'Dic' ('dic_word' VARCHAR(30), 'dic_json' VARCHAR(500))";
            res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"error when create DIC table");
            }
        }
    }];
}

/*
- (NSString *)getImagePathForImageID:(NSString *)imageID
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select * from IMG where img_id = ?";
        FMResultSet *rs = [db executeQuery:sql,imageID];
        
    }];
    
}

- (NSString *)setImagePathToImageID:(NSString *)imageID
{
    
}

- (NSString *)getDicJsonForWord:(NSString *)word
{
    
}

- (NSString *)setDicJsonForWord:(NSString *)word
{
    
}

 */
@end
