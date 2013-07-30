//
//  NPLViewController.m
//  PannableTableViewSample
//
//  Created by Nephilim on 13. 7. 28..
//  Copyright (c) 2013년 Dongwook Lee. All rights reserved.
//

#import "NPLViewController.h"

@interface NPLViewController (Private)

- (UIView*)loadCellForeground;
- (UIView*)loadCellBackground;

@end

@implementation NPLViewController {
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
    pannableCell = [self.tableView dequeueReusableCellWithIdentifier:PANNABLE_TABLEVIEWCELL_REUSE_ID];
    if (pannableCell == nil) {
        UIView* foreground = [self loadCellForeground];
        UIView* background = [self loadCellBackground];
        pannableCell = [[NPLPannableTableViewCell alloc] initWithReuseIdentifier:PANNABLE_TABLEVIEWCELL_REUSE_ID
                                                                      foreground:foreground
                                                                      background:background
                                                                      openToPosX:0
                                                                     closeToPosX:0
                                                                       tableView:self.tableView
                                                                         groupId:AUTOGENERATE_GROUP_ID];
        // set block to perform before opening/after closing cell
        [pannableCell setPerformBeforeOpening:^(NPLPannableTableViewCell* cell){
            NSLog(@"cell is about to be opened.");
        }];
        [pannableCell setPerformAfterClosing:^(NPLPannableTableViewCell* cell) {
            NSLog(@"cell is just closed");
        }];
    } else {
        [pannableCell resetToInitPositionAt:indexPath ];
    }

    // Databinding
    /*
    UILabel* description = (UILabel*)[cell viewWithTag:kDescriptionTag];
    description.text = myItem.description;
    */
    
    return pannableCell;
}

@end
