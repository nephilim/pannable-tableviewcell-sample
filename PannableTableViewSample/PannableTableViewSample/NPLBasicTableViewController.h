//
//  NPLBasicTableViewController.h
//  PannableTableViewSample
//
//  Created by Nephilim on 13. 7. 28..
//  Copyright (c) 2013년 Dongwook Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPLPannableTableViewCell.h"


@interface NPLBasicTableViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView* tableView;

- (void)openTwoTableViewController;
- (void)openManyCellsViewController;

@end
