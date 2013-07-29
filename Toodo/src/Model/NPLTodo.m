//
//  NPLTodo.m
//
//  Created by 1000820 on 12. 6. 1..
//  Copyright (c) 2012년 YakShavingLocus. All rights reserved.
//

#import "NPLTodo.h"

@implementation NPLTodo

@synthesize title = title_,
      description = description_;

-(NPLTodo*)initWithTitle:(NSString *)title 
             description:(NSString *)desc {
    self = [super init];
    if ( self != nil) {
        self.title = title;
        self.description = desc;
    }
    return self;
}

@end
