//
//  NPLTodoDataAccess.h
//  Toodo
//  
//  todo 정보 접근을 위한 기본적 access api를 정의한 프로토콜
//
//  Created by 1000820 on 12. 6. 1..
//  Copyright (c) 2012년 YakShavingLocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPLTodo.h"

@protocol NPLTodoDataAccess <NSObject>

-(void) addTodo:(NPLTodo*) todoItem;
//-(void) removeTodo:(NPLTodo*) todoItem;
//-(void) getTodo:(NPLTodo*) todoItem;

@end
