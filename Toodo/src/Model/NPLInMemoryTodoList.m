//
//  NPLMemoryTodoList.m
//  Toodo
//
//  Created by 1000820 on 12. 6. 1..
//  Copyright (c) 2012년 YakShavingLocus. All rights reserved.
//

#import "NPLInMemoryTodoList.h"

@interface NPLInMemoryTodoList(Private)

- (void)initializeArray;

@end 

@implementation NPLInMemoryTodoList

@synthesize todoItems;

+(id) sharedInstance 
{
    static NPLInMemoryTodoList* todoList = nil;
    if ( !todoList ) {
        @synchronized(self) {
            todoList = [[self alloc] init];
            [todoList initializeArray];
        }
    }
    return todoList;
}

#pragma mark Array 조회 관련 메서드 

-(int) count {
    return [todoItems_ count];
}

-(NPLTodo*)todoAtIndex:(int)index {
    return (NPLTodo*)[todoItems_ objectAtIndex:index];
}

#pragma mark 초기화 initialize array

-(void) initializeArray
{
    NPLTodo* todo01 = [[NPLTodo alloc] initWithTitle:@"Things to do1" 
                                         description:@"Description 1: blah blah blah"];
    NPLTodo* todo02 = [[NPLTodo alloc] initWithTitle:@"Things to do2"
                                         description:@"Description 2: blah blah blah"];
    NPLTodo* todo03 = [[NPLTodo alloc] initWithTitle:@"Things to do3"
                                         description:@"Description 3: blah blah blah"];
    NPLTodo* todo04 = [[NPLTodo alloc] initWithTitle:@"Things to do4"
                                         description:@"Description 4: blah blah blah"];
    NPLTodo* todo05 = [[NPLTodo alloc] initWithTitle:@"Things to do5"
                                         description:@"Description 5: blah blah blah"];
    NPLTodo* todo06 = [[NPLTodo alloc] initWithTitle:@"Things to do6"
                                         description:@"Description 6: blah blah blah"];
    NPLTodo* todo07 = [[NPLTodo alloc] initWithTitle:@"Things to do7"
                                         description:@"Description 7: blah blah blah"];
    NPLTodo* todo08 = [[NPLTodo alloc] initWithTitle:@"Things to do8"
                                         description:@"Description 8: blah blah blah"];
    NPLTodo* todo09 = [[NPLTodo alloc] initWithTitle:@"Things to do9"
                                         description:@"Description 9: blah blah blah"];

    todoItems_ = [[NSMutableArray alloc] initWithObjects:todo01, todo02, todo03, todo04, todo05, todo06, todo07, todo08, todo09, nil];
}

#pragma mark NPLTodoDataAccess 프로토콜 구현

-(void) addTodo:(NPLTodo*)todoItem {
    [todoItems_ addObject:todoItem];
    NSLog(@"todoitem size %d", [self count]);
}

@end
