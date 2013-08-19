//
//  NPLTwoTableViewController.m
//  PannableTableViewSample
//
//  Created by Nephilim on 13. 8. 12..
//  Copyright (c) 2013년 Dongwook Lee. All rights reserved.
//

#import "NPLTwoTableViewController.h"

#define TABLEVIEW_GROUP_ID @"group-id:two-table"
#define PANNABLE_TABLEVIEWCELL_REUSE_ID @"pannable-cell:two-table"
#define TABLEVIEWCELL_COUNT 100

#define TAG_NO_INDEX_LABEL 9

#define TAG_NO_LABEL1     1
#define TAG_NO_TABLEVIEW1 2
#define TAG_NO_LABEL2     3
#define TAG_NO_TABLEVIEW2 4


@interface NPLTwoTableViewController ()

@end

@implementation NPLTwoTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // two table views use the same shape of table view cell
    CGFloat fgCellHeight = [self loadCellForeground].bounds.size.height;
    CGFloat bgCellHeight = [self loadCellBackground].bounds.size.height;
    self.cellHeight = fmax(fgCellHeight, bgCellHeight);

    // initiallize table view
    UIView* rootView = self.view;
    self.tableView1 = (UITableView *) [rootView viewWithTag:TAG_NO_TABLEVIEW1];
    self.tableView2 = (UITableView *) [rootView viewWithTag:TAG_NO_TABLEVIEW2];

    [self.tableView1 setDelegate:self];
    [self.tableView1 setDataSource:self];

    [self.tableView2 setDelegate:self];
    [self.tableView2 setDataSource:self];

    rootView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight;

}

- (void)viewWillAppear:(BOOL)animated {
    // toolbar
    UIBarButtonItem *basicTableBtn = [[UIBarButtonItem alloc] initWithTitle:@"Basic-Table"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(openBasicTableViewController)];
    UIBarButtonItem *manyCellsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Many-Cells"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(openManyCellsViewController)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                 target:nil
                                 action:nil];
    [self setToolbarItems:[NSArray arrayWithObjects:flexibleSpace, basicTableBtn, flexibleSpace, manyCellsBtn,
                                                        flexibleSpace, nil]];

}

- (void)openBasicTableViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)openManyCellsViewController {
    NPLViewControllerList *viewControllerList = [NPLViewControllerList sharedInstance];
    UIViewController *manyCellsViewCtrl = [viewControllerList viewControllerForKey:KEY_MANYCELLS_VIEWCTRLER];

    if ( [[self.navigationController viewControllers] indexOfObject:manyCellsViewCtrl] == NSNotFound ) {
        [self.navigationController pushViewController:manyCellsViewCtrl animated:YES];
    } else {
        [self.navigationController popToViewController:manyCellsViewCtrl animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load table veiw cell

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

# pragma mark - table view datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
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

        // tableview1 and tableview2 share the same group id.
        // if groupId is set AUTOGENERATE_GROUP_ID, the group id is allocated on each table separately
        pannableCell = [[NPLPannableTableViewCell alloc] initWithReuseIdentifier:PANNABLE_TABLEVIEWCELL_REUSE_ID
                                                                      foreground:foreground
                                                                      background:background
                                                                      openToPosX:0
                                                                     closeToPosX:0
                                                                       tableView:tableView
                                                                         groupId:TABLEVIEW_GROUP_ID];
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
