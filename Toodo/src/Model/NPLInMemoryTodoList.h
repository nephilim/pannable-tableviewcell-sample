//
//  NPLMemoryTodoList.h
//  Toodo
//
//  Created by 1000820 on 12. 6. 1..z
//  Copyright (c) 2012년 YakShavingLocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPLTodoDataAccess.h"
#import "NPLTodo.h" 

@interface NPLInMemoryTodoList: NSObject<NPLTodoDataAccess> {
    NSMutableArray* todoItems_;
}

+(id)sharedInstance;

-(int)count;
-(NPLTodo*)todoAtIndex:(int)index;

@property (strong, nonatomic) NSMutableArray* todoItems;

@end