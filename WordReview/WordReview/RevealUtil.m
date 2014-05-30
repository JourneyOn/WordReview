//
//  RevealUtil.m
//  WordReview
//
//  Created by shupeng on 5/30/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "RevealUtil.h"
#import <dlfcn.h>

@interface RevealUtil ()
{
    void *_revealLib;
}
@end


@implementation RevealUtil

- (void)startReveal
{
    NSString *revealLibName = @"libReveal.dylib";
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dyLibPath = [documentDir stringByAppendingPathComponent:revealLibName];
    
    _revealLib = dlopen([dyLibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
    
    if (_revealLib == NULL) {
        char *error = dlerror();
        NSLog(@"dlopen error: %s", error);
    }

    
}


- (void)stopReveal
{
    if (_revealLib) {
        if (dlclose(_revealLib) == 0) {
            _revealLib = NULL;
        }
        else{
            char *error = dlerror();
            NSLog(@"Reveal library could not unloaded: %s", error);
        }
    }
}
@end
