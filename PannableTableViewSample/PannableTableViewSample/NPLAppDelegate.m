//
//  NPLAppDelegate.m
//  PannableTableViewSample
//
//  Created by Nephilim on 13. 7. 28..
//  Copyright (c) 2013년 Dongwook Lee. All rights reserved.
//

#import "NPLAppDelegate.h"
#import "NPLBasicTableViewController.h"
#import "NPLViewControllerList.h"
#import "NPLTwoTableViewController.h"
#import "NPLManyCellsViewController.h"

@implementation NPLAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    // navigation controller setting
    UIViewController *rootViewController = [[NPLBasicTableViewController alloc] initWithNibName:@"NPLViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];

    UIViewController *twoTableViewCtrl = [[NPLTwoTableViewController alloc]
            initWithNibName:@"NPLTwoTableViewController"
                                                                           bundle:nil];
    UIViewController *manyCellsViewCtrl = [[NPLManyCellsViewController alloc]
            initWithNibName:@"NPLManyCellsViewController"
                                                                           bundle:nil];

    NPLViewControllerList *viewControllers = [NPLViewControllerList sharedInstance];

    [viewControllers setViewControllerForKey:KEY_TWOTABLE_VIEWCTRLER
                              viewController:twoTableViewCtrl];
    [viewControllers setViewControllerForKey:KEY_MANYCELLS_VIEWCTRLER
                              viewController:manyCellsViewCtrl];
    navController.toolbarHidden = NO;
    navController.navigationBarHidden = YES;

    [[self window] setRootViewController:navController];
    [self.window makeKeyAndVisible];
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

@end
