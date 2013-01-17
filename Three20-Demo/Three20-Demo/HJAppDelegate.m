//
//  HJAppDelegate.m
//  Three20-Demo
//
//  Created by haoyu on 13-1-11.
//  Copyright (c) 2013年 haoyu. All rights reserved.
//

#import "HJAppDelegate.h"
#import "TDDefaultStyleSheet.h"

#import "TDGroupedTableViewController.h"
#import "TDDemoListViewController.h"
#import "TDNewsListViewController.h"
#import "TDWebViewController.h"

@implementation HJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
     */
    
    [self three20Lanuch];
    return YES;
}

- (void)three20Lanuch
{
    TDDefaultStyleSheet *style = [[TDDefaultStyleSheet alloc]init];
    [TTStyleSheet setGlobalStyleSheet:style];
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.supportsShakeToReload = YES;
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    navigator.window = [[UIWindow alloc] initWithFrame:TTScreenBounds()];
    
    TTURLMap* map = navigator.URLMap;
    
    // Any URL that doesn't match will fall back on this one, and open in the web browser
    [map from:@"*" toViewController:[TTWebController class]];
    
    [map from:@"tt://demolist" toSharedViewController:[TDDemoListViewController class]];
    [map from:@"tt://grouped-table" toSharedViewController:[TDGroupedTableViewController class]];
    [map from:@"tt://html-parser" toSharedViewController:[TDNewsListViewController class]];
    [map from:@"tt://webview" toSharedViewController:[TDWebViewController class]];

    if (![navigator restoreViewControllers])
     {
     [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://demolist"]];
     
     }

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

@end
