//
//  AppDelegate.m
//  WordReview
//
//  Created by shupeng on 5/4/14.
//  Copyright (c) 2014 John. All rights reserved.
//
#import <dlfcn.h>


#import "AppDelegate.h"
#import "DataModelManager.h"
#import "WRUser.h"

#import "RootTabbarViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"

#import <PonyDebugger/PonyDebugger.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
#if DEBUG
    [self setupDebug];
#endif
    
    [self setupDataModelWithLaunchOptions:launchOptions];
    [self setupCache];
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
- (void)setupDebug
{
//    PDDebugger *debugger = [PDDebugger defaultInstance];
//    [debugger autoConnect];
//    [debugger enableNetworkTrafficDebugging];
//    [debugger forwardAllNetworkTraffic];
//    [debugger enableRemoteLogging];
//    [debugger enableViewHierarchyDebugging];
    
    [self loadReveal];
    
}

- (void)loadReveal
{
    NSString *revealLibName = @"libReveal";
    NSString *revealLibExtension = @"dylib";
    NSString *dyLibPath = [[NSBundle mainBundle] pathForResource:revealLibName ofType:revealLibExtension];
    NSLog(@"Loading dynamic library: %@", dyLibPath);
    
    void *revealLib = NULL;
    revealLib = dlopen([dyLibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
    
    if (revealLib == NULL)
    {
        char *error = dlerror();
        NSLog(@"dlopen error: %s", error);
        NSString *message = [NSString stringWithFormat:@"%@.%@ failed to load with error: %s", revealLibName, revealLibExtension, error];
        [[[UIAlertView alloc] initWithTitle:@"Reveal library could not be loaded" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)setupDataModelWithLaunchOptions:(NSDictionary *)option
{
    [[DataModelManager sharedInstance] setupAVOSCloudWithLaunchOpltions:option];
}

- (void)setupCache
{
    [[DataModelManager sharedInstance] setupCache];
}

- (void)setupRootView
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    /*
     NAV -> TAB -> NAV -> Home
                -> NAV -> Profile
     */
    
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.title = @"Word Review";
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Word Review" image:[UIImage imageNamed:@"word_review.png"] selectedImage:nil];
    UINavigationController *homeNAV = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    profileVC.title = @"Profile";
    profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"profile.png"] selectedImage:nil];
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
