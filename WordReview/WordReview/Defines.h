//
//  Defines.h
//  WordReview
//
//  Created by shupeng on 5/7/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#ifndef WordReview_Defines_h
#define WordReview_Defines_h

#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
#define VIEW_BEGIN_Y (IS_IOS7 ? 20 : 0)
#define NAV_HEIGHT 44




#define SERVER_YOUDAO_FULL                  @"YouDaoServer_Full"
#define SERVER_YOUDAO_COLLINS               @"YouDaoServer_Collins"
#define SERVER_YOUDAO_PRONOUNCE_ENGLISH     @"YouDaoPronounce_english"
#define SERVER_YOUDAO_PRONOUNCE_AMERICA     @"YouDaoPronounce_america"
#endif
