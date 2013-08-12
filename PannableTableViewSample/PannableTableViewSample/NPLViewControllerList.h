//
// Created by Nephilim on 13. 8. 12..
// Copyright (c) 2013 Dongwook Lee. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#define KEY_TWOTABLE_VIEWCTRLER     @"two-table"
#define KEY_MANYCELLS_VIEWCTRLER    @"many-cells"

@interface NPLViewControllerList : NSObject {
    NSMutableDictionary *viewControllers;
}

+ (NPLViewControllerList *)sharedInstance;

- (void)setViewControllerForKey:(NSString *)key viewController:(UIViewController *)viewController;
- (UIViewController *)viewControllerForKey:(NSString *)key;

@end