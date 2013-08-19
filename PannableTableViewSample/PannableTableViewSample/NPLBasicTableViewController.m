//
//  NPLBasicTableViewController.m
//  PannableTableViewSample
//
//  Created by Nephilim on 13. 7. 28..
//  Copyright (c) 2013년 Dongwook Lee. All rights reserved.
//

#import "NPLBasicTableViewController.h"
#import "NPLViewControllerList.h"

#define TABLEVIEWCELL_COUNT 100
#define PANNABLE_TABLEVIEWCELL_REUSE_ID @"pannable-cell:basic-table"

#define TAG_NO_INDEX_LABEL 9

@interface NPLBasicTableViewController (Private)

- (UIView*)loadCellForeground;
- (UIView*)loadCellBackground;

- (void)prepareToolbar;

@end

@implementation NPLBasicTableViewController {
    CGFloat cellHeight;
}

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];

    CGFloat fgCellHeight = [self loadCellForeground].bounds.size.height;
    CGFloat bgCellHeight = [self loadCellBackground].bounds.size.height;
    cellHeight = fmax(fgCellHeight, bgCellHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    // toolbar
    UIBarButtonItem *twoTableBtn = [[UIBarButtonItem alloc] initWithTitle:@"Two-Tables"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(openTwoTableViewController)];
    UIBarButtonItem *manyCellsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Many-Cells"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(openManyCellsViewController)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                 target:nil
                                 action:nil];
    [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, twoTableBtn, flexibleSpace, manyCellsBtn,
                    flexibleSpace, nil]];
}

- (void)openTwoTableViewController {
    [self.navigationController popViewControllerAnimated:NO];

    NPLViewControllerList *viewControllerList = [NPLViewControllerList sharedInstance];
    UIViewController *twoTableViewCtrl = [viewControllerList viewControllerForKey:KEY_TWOTABLE_VIEWCTRLER];
    [self.navigationController pushViewController:twoTableViewCtrl animated:YES];
}

- (void)openManyCellsViewController {
    [self.navigationController popViewControllerAnimated:NO];

    NPLViewControllerList *viewControllerList = [NPLViewControllerList sharedInstance];
    UIViewController *manyCellsViewCtrl = [viewControllerList viewControllerForKey:KEY_MANYCELLS_VIEWCTRLER];
    [self.navigationController pushViewController:manyCellsViewCtrl animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// load uiviews for tableviewcell's foreground/background

- (UIView*)loadCellForeground {
     return [[[NSBundle mainBundle] loadNibNamed:@"NPLTodoTableCell"
                                          owner:self
                                        options:nil] objectAtIndex:0];
}

- (UIView*)loadCellBackground {
    return [[[NSBundle mainBundle] loadNibNamed:@"NPLTodoTableCell"
                                          owner:self
                                        options:nil] objectAtIndex:1];
}

#pragma mark - UITableView delegate/datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TABLEVIEWCELL_COUNT;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NPLPannableTableViewCell* pannableCell = nil;
    pannableCell = [tableView dequeueReusableCellWithIdentifier:PANNABLE_TABLEVIEWCELL_REUSE_ID];
    if (pannableCell == nil) {
        UIView* foreground = [self loadCellForeground];
        UIView* background = [self loadCellBackground];
        pannableCell = [[NPLPannableTableViewCell alloc] initWithReuseIdentifier:PANNABLE_TABLEVIEWCELL_REUSE_ID
                                                                      foreground:foreground
                                                                      background:background
                                                                      openToPosX:0
                                                                     closeToPosX:0
                                                                       tableView:tableView
                                                                         groupId:AUTOGENERATE_GROUP_ID];
        // set block to perform before opening/after closing cell
        [pannableCell setPerformBeforeOpening:^(NPLPannableTableViewCell* cell){
            NSLog(@"cell is about to be opened.");
        }];
        [pannableCell setPerformAfterClosing:^(NPLPannableTableViewCell* cell) {
            NSLog(@"cell is just closed");
        }];
    } else {
        [pannableCell resetToInitPositionAt:indexPath];
    }

    // Databinding
    UILabel *indexNumber = (UILabel*)[pannableCell.panningForegroundView viewWithTag:TAG_NO_INDEX_LABEL];
    indexNumber.text = [NSString stringWithFormat:@"%d", indexPath.row];

    return pannableCell;
}

@end
