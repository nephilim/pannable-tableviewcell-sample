//
//  NPLTwoTableViewController.h
//  PannableTableViewSample
//
//  Created by Nephilim on 13. 8. 12..
//  Copyright (c) 2013년 Dongwook Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NPLViewControllerList.h"
#import "NPLPannableTableViewCell.h"

@interface NPLTwoTableViewController : UIViewController

@property(nonatomic, strong) UITableView *tableView1;
@property(nonatomic, strong) UITableView *tableView2;
@property(nonatomic) double cellHeight;

@end
