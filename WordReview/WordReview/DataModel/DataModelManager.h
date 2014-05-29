//
//  DataModelManager.h
//  WordReview
//
//  Created by shupeng on 5/7/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModelManager : NSObject

+ (id)sharedInstance;



/**********    AVOS Cloud             **********/

- (void)setupAVOSCloudWithLaunchOpltions:(NSDictionary *)option;

- (void)initAVSubClass;

- (NSString *)getServerByKey:(NSString *)key;



/**********    IMG & DIC DATABASE     **********/
- (void)setupCache;

- (NSString *)getImagePathForImageID:(NSString *)imageID;
- (NSString *)setImagePathToImageID:(NSString *)imageID;
- (NSString *)getDicJsonForWord:(NSString *)word;
- (NSString *)setDicJsonForWord:(NSString *)word;
@end
