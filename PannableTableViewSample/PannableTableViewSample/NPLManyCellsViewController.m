//
//  NPLManyCellsViewController.m
//  PannableTableViewSample
//
//  Created by Nephilim on 13. 8. 12..
//  Copyright (c) 2013년 Dongwook Lee. All rights reserved.
//

#import "NPLManyCellsViewController.h"
#import "NPLViewControllerList.h"

@interface NPLManyCellsViewController ()

@end

@implementation NPLManyCellsViewController

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
    UIBarButtonItem *manyCellsBtn = [[UIBarButtonItem alloc] initWithTitle:@"Two-Table"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(openTwoTableViewController)];
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

- (void)openTwoTableViewController {
    NPLViewControllerList *viewControllerList = [NPLViewControllerList sharedInstance];
    UIViewController *twoTableViewCtrl = [viewControllerList viewControllerForKey:KEY_TWOTABLE_VIEWCTRLER];

    if ( [[self.navigationController viewControllers] indexOfObject:twoTableViewCtrl] == NSNotFound ) {
        [self.navigationController pushViewController:twoTableViewCtrl animated:YES];
    } else {
        [self.navigationController popToViewController:twoTableViewCtrl animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
