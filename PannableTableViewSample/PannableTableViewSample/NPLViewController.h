//
//  NPLViewController.h
//  PannableTableViewSample
//
//  Created by Nephilim on 13. 7. 28..
//  Copyright (c) 2013년 Dongwook Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPLPannableTableViewCell.h"

#define TABLEVIEWCELL_COUNT 100
#define PANNABLE_TABLEVIEWCELL_REUSE_ID @"pannable-cell"

@interface NPLViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end
