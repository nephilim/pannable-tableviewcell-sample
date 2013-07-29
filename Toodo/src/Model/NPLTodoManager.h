//
//  NPLTodoManager.h
//  Toodo
//
//  Created by 1000820 on 12. 5. 31..
//  Copyright (c) 2012년 YakShavingLocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NPLTodoManager <NSObject>

-(void) addTodoWithTitle:(NSString*)title description:(NSString*)string;

@end
