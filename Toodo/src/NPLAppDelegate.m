//
//  NPLAppDelegate.m
//  Toodo
//
//  Created by 1000820 on 12. 5. 29..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#define KEY_TITLE @"title"
#define KEY_DESC @"description"
#define KEY_RETURN_URL @"returnUrl"

#import "NPLAppDelegate.h"
#import "NPLViewController.h"

@implementation NPLAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_RETURN_URL];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[NPLViewController alloc] initWithNibName:@"NPLViewController" bundle:nil];
    self.window.rootViewController = self.viewController;   
    [self.viewController organizeToolbar];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    NSDictionary* params = [self urlParamDictionaryFromQuery:[url absoluteString]];
    //NSLog(@"params %@", params );
    NSString* title = [params objectForKey:KEY_TITLE];
    NSString* description = [params objectForKey:KEY_DESC];
    //NSLog(@"about to create todo: %@, %@", title, description);
    
    NSString* returnUrl = [params objectForKey:KEY_RETURN_URL];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:returnUrl forKey:KEY_RETURN_URL];
    
    NPLTodo* todo = [[NPLTodo alloc]initWithTitle:title description:description];
    [[NPLInMemoryTodoList sharedInstance] addTodo:todo];
    [self.viewController refreshTableView]; 
    [self.viewController organizeToolbar];
    return YES;
}

#pragma mark URL param parsing

-(NSDictionary*) urlParamDictionaryFromQuery:(NSString*)urlString {
    NSString* queryString = [[urlString componentsSeparatedByString:@"?"] objectAtIndex:1];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSArray* pairs = [queryString componentsSeparatedByString:@"&"];
    for (NSString* param  in pairs) {
        NSArray* elts = [param componentsSeparatedByString:@"="];
        if ([elts count] < 2) continue;
        NSString* value = (NSString*)[elts objectAtIndex:1];
        value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:value forKey:[elts objectAtIndex:0]];
    }
    
    return params;
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
