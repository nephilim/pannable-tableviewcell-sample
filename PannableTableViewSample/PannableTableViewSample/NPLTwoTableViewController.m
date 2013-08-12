//
//  NPLTwoTableViewController.m
//  PannableTableViewSample
//
//  Created by Nephilim on 13. 8. 12..
//  Copyright (c) 2013년 Dongwook Lee. All rights reserved.
//

#import "NPLTwoTableViewController.h"
#import "NPLViewControllerList.h"

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

@end
