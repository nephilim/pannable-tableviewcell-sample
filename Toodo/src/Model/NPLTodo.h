//
//  NPLTodo.h
//  Toodo
//
//  Created by 1000820 on 12. 6. 1..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPLTodo : NSObject {
    NSString* title_;
    NSString* description_;
    UIImage* photo_;
}

@property(strong, nonatomic) NSString* title;
@property(strong, nonatomic) NSString* description;

#pragma mark initializer
- (NPLTodo*) initWithTitle:(NSString*)title 
                description:(NSString*)desc;
@end
