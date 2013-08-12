//
// Created by Nephilim on 13. 8. 12..
// Copyright (c) 2013 Dongwook Lee. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NPLViewControllerList.h"

static NPLViewControllerList *sharedInstance = nil;

@implementation NPLViewControllerList

+ (NPLViewControllerList *)sharedInstance
{
    @synchronized (self) {
        if (sharedInstance == nil) {
            sharedInstance = [[NPLViewControllerList alloc] init];
        }
        return sharedInstance;
    }
}

- (id) init {
    self = [super init];
    if (self) {
        viewControllers = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return self;
}

- (void) setViewControllerForKey:(NSString*)key viewController:(UIViewController *)viewController
{
    [viewControllers setObject:viewController forKey:key];
}

- (UIViewController *) viewControllerForKey:(NSString*)key
{
    return [viewControllers objectForKey:key];
}

@end