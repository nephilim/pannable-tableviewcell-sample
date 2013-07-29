//
//  NPLViewController.h
//  Toodo
//
//  Created by 1000820 on 12. 5. 29..
//  Copyright (c) 2012년 YakShavingLocus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NPLTodoManager.h"
#import "NPLInMemoryTodoList.h"
#import "NPLZoomableTableView.h"
#import "NPLPannableTableViewCell.h"


@interface NPLViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, NPLTodoManager>
{
    NPLInMemoryTodoList* todoList;
    UIButton* floatingMenuBtn;
    
    CGFloat cellSizeZoomed;
    CGFloat cellSizeNormal;
}

- (void) refreshTableView;
- (void) organizeToolbar;

# pragma mark - TableView UI 관련

@property (nonatomic, retain) IBOutlet NPLZoomableTableView* tableView;
@property (nonatomic, retain) UIButton* floatingMenuBtn;

- (IBAction)finish:(id)sender;


@end

