//
//  AppDelegate.m
//  WordReview
//
//  Created by shupeng on 5/4/14.
//  Copyright (c) 2014 John. All rights reserved.
//

#import "AppDelegate.h"
#import "DataModelManager.h"
#import "WRUser.h"

#import "RootTabbarViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setupDataModelWithLaunchOptions:launchOptions];
    [self setupRootView];
    
    [self doLoginProcess];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Process
- (void)setupDataModelWithLaunchOptions:(NSDictionary *)option
{
    [[DataModelManager sharedInstance] setupAVOSCloudWithLaunchOpltions:option];
}

- (void)setupRootView
{
    /*
     NAV -> TAB -> NAV -> Home
                -> NAV -> Profile
     */
    
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.title = @"Word Review";
    UINavigationController *homeNAV = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    profileVC.title = @"Profile";
    UINavigationController *profileNAV = [[UINavigationController alloc] initWithRootViewController:profileVC];
    
    RootTabbarViewController *tabbarVC = [[RootTabbarViewController alloc] init];
    [tabbarVC setViewControllers:@[homeNAV, profileNAV]];
    UINavigationController *rootNAV = [[UINavigationController alloc] initWithRootViewController:tabbarVC];
    rootNAV.navigationBarHidden = YES;
    
    self.window.rootViewController = rootNAV;
}

- (void)doLoginProcess
{
    WRUser *user = [WRUser currentUser];
    if (user != nil) {
        // do something after user login
        
    }
    else{
        // move login process at root view appeared!
    }
}

@end
