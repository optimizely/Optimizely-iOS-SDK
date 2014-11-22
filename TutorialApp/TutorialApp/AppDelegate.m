//
//  AppDelegate.m
//  TutorialApp
//
//  This Optimizely Tutorial app will teach you how to use Optimizely's iOS SDK's
//  3 key features:
//     - Visual Editor
//     - Live Variables
//     - Code Blocks
//
//  Created by Tony Zhang on 9/22/14.
//  Copyright (c) 2014 Optimizely. All rights reserved.
//

#import "AppDelegate.h"
#import <Optimizely/Optimizely.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Below are instructions for initial setup, lines marked as optional
    // are options, lines marked as required are required
    // Throughout the code, you can search for [OPTIMIZELY] to find reference code
    // related to Optimizely
    // All lines that say [OPTIMIZELY] (REQUIRED) are necessary for you to
    // get started!

    // [OPTIMIZELY] (OPTIONAL) Add this line of code to debug issues.  Please note that this line of code
    // should not be included when your app is in production
    [Optimizely sharedInstance].verboseLogging = YES;
    
    // [OPTIMIZELY] (OPTIONAL) Add this line of code if you would like to enable "Edit Mode" in your live app
    // Please note that adding this line will allow anyone to edit your app with
    // Optimizely in the app store
    [Optimizely enableGestureInAppStoreApp];
    
    // [OPTIMIZELY] (OPTIONAL) Customize network call timing (By default network calls are made every 2 minutes)
    // [Optimizely sharedInstance].dispatchInterval = 120;
    
    // [OPTIMIZELY] (REQUIRED) Replace this line with your API token, and don't forget to go to
    // your target (i.e. the blue icon at the top that says TutorialApp) > Info > URL Types
    // Paste your Project ID there (e.g. it should look like optly123456
    [Optimizely startOptimizelyWithAPIToken:
     @"AAMseu0A6cJKXYL7RiH_TgxkvTRMOCvS~123456"
                              launchOptions:launchOptions];
    
    // [OPTIMIZELY] (OPTIONAL) Mixpanel Integration Instructions and order
    // Optimizely Mixpanel Integration goes here
    // Mixpanel Activation goes here
    
    // GA Example
    

    // Change NavBar Background color
    UINavigationBar *defaultNavBar = [UINavigationBar appearance];
    defaultNavBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:51.0/255.0 blue:102.0/255.0 alpha:1.0];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Gotham-Light" size:20.0f]
                                                            }];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    // [OPTIMIZELY] (REQUIRED) Be sure to add this entire method.
    // If you use other tools such as AdX, you will need to make sure that
    // Optimizely's handleOpenURL is called first.  This allows you to connect
    // the app with Optimizely's editor.
    if ([Optimizely handleOpenURL:url]) {
        return YES;
    }
    
    // Other implementations (e.g. AdX) would start here

    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
