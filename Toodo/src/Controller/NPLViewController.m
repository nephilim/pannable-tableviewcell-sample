//
//  NPLViewController.m
//  Toodo
//
//  Created by 1000820 on 12. 5. 29..
//  Copyright (c) 2012년 YakShavingLocus. All rights reserved.
//


#define TAG_TOOLBAR 900
#define TAG_TABLEVIEW 100
#define TABLEVIEW_ID @"toodo-tableview"
#define PANNABLE_TABLEVIEWCELL_ID @"pannable-tableviewcell"
#define ZOOMED_TABLEVIEWCELL_ID @"zoomed-tableviewcell"
#import "NPLViewController.h"

@interface NPLViewController (Private)

- (void) refreshTableView;
- (UIImageView*) floatHubble;

- (UITableViewCell*)loadZoomedCell;
- (UITableViewCell*)loadNormalCellForeground;
- (UITableViewCell*)loadNormalCellBackground;
@end

@implementation NPLViewController

@synthesize floatingMenuBtn;

#pragma mark Todo Manager 프로토콜 구현 

- (void) addTodoWithTitle:(NSString *)title 
              description:(NSString*)desc {
    [[NPLInMemoryTodoList sharedInstance] addTodoWithTitle:title
                                             description:desc];
    // TODO: refresh table view 
    [self refreshTableView];
}

#pragma mark TableView의 라이프 사이클 관리

- (void) refreshTableView {
    UITableView* tableView = (UITableView*)[self.view viewWithTag:100];
    [tableView reloadData];
    
}

- (IBAction)finish:(id)sender {
    exit(0);
}

#pragma mark TableViewDataSource 관련 protocol 구현

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [todoList count];
}

- (UITableViewCell*)loadZoomedCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"NPLTodoTableCellMedium"
                                          owner:self
                                        options:nil] objectAtIndex:0];
}

- (UIView*)loadNormalCellForeground {
    return [[[NSBundle mainBundle] loadNibNamed:@"NPLTodoTableCell"
                                          owner:self
                                        options:nil] objectAtIndex:0];
}

- (UIView*)loadNormalCellBackground {
    return [[[NSBundle mainBundle] loadNibNamed:@"NPLTodoTableCell"
                                          owner:self
                                        options:nil] objectAtIndex:1];
}


- (UITableViewCell*)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static int const kTitleTag = 1;
    static int const kDescriptionTag = 2;
    
    NPLZoomableTableView* zoomableTableView = (NPLZoomableTableView*)self.tableView;
    NSIndexPath* expandedIndexPath = self.tableView.prevExpandedCellIndex;
    UITableViewCell* cell = nil;
    
    if ( expandedIndexPath != nil &&
        [expandedIndexPath isEqual:indexPath]) {
        // TODO: cache nib loading
        cell = [self loadZoomedCell];
        
        if (cellSizeZoomed == 0.0) {
            cellSizeZoomed = cell.bounds.size.height;
        }
        
    } else {
        NPLPannableTableViewCell* pannableCell = nil;
        pannableCell = [self.tableView dequeueReusableCellWithIdentifier:PANNABLE_TABLEVIEWCELL_ID];
        if (pannableCell == nil) {
            UIView* foreground = [self loadNormalCellForeground];
            UIView* background = [self loadNormalCellBackground];
            pannableCell = [[NPLPannableTableViewCell alloc] initWithReuseIdentifier:PANNABLE_TABLEVIEWCELL_ID
                                                                  foreground:foreground
                                                                  background:background
                                                                  openToPosX:0
                                                                 closeToPosX:0
                                                                 tableViewIdentifier:TABLEVIEW_ID];
            [pannableCell setPerformBeforeOpening:^(NPLPannableTableViewCell* cell){
                [zoomableTableView closeExpandedCell];
            }];
        }
        cell = pannableCell;
        
        // Databinding
        
        NPLTodo* todoItem = [todoList todoAtIndex:indexPath.row];
        //    cell.textLabel.text = todoItem.title;
        //    cell.detailTextLabel.text = todoItem.description;
        UILabel* title = (UILabel*)[cell viewWithTag:kTitleTag];
        title.text = todoItem.title;
            
        UILabel* description = (UILabel*)[cell viewWithTag:kDescriptionTag];
        description.text = todoItem.description;
    }
    
    return cell;
}

#pragma mark - TableView selection


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NPLZoomableTableView* zoomableTableView = (NPLZoomableTableView*)tableView;
    NSIndexPath* expandedIndexPath = zoomableTableView.prevExpandedCellIndex;
    
    CGFloat height = 0;
    if (expandedIndexPath != nil && expandedIndexPath.row == indexPath.row) {
        height = cellSizeZoomed;
    }
    else
        height = cellSizeNormal;

    return height;
}

#pragma mark ViewController 관련 메서드
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NPLZoomableTableView* tableView = (NPLZoomableTableView*)self.tableView;
    [tableView setDelegate:self];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // contents
    todoList = [NPLInMemoryTodoList sharedInstance];
    
    // table view header from NPLTableHeaderView.xib
    UIView* headerView= (UIView*)[[[NSBundle mainBundle] loadNibNamed:@"NPLTableHeaderView"
                                                                owner:self
                                                    options:nil] objectAtIndex:0];
    tableView.tableHeaderView = headerView;
    
    
    // cell size initialization
    cellSizeZoomed = [self loadZoomedCell].bounds.size.height;
    cellSizeNormal = fmax([self loadNormalCellForeground].bounds.size.height,
                          [self loadNormalCellBackground].bounds.size.height);
    
    // Initialize and float the "Hubble" icon
    
    //self.floatingMenuBtn = [self floatHubble];
    //[self.tableView addSubview:self.floatingMenuBtn];
    //[self locateHubbleButton];
}


#pragma mark Floating Menu: temporarily floating hubble

-(UIButton*) floatHubble {
    
    UIButton* floatingButton = nil;
    
    if ( self.floatingMenuBtn) {
        NSLog(@"already initialized");
    } else {
        /*
        CGRect tableBounds = self.tableView.bounds;
        
        UIImage* hubbleImage = [UIImage imageNamed:@"hubble-icon.png"];
        floatingImage = [[UIImageView alloc] initWithImage:hubbleImage];
        
        CGSize hubbleImgSize = floatingImage.image.size;
        CGPoint hubbleImgOrigin = CGPointMake(CGRectGetMaxX(tableBounds) - hubbleImgSize.width - 10,
                                              CGRectGetMaxY(tableBounds) - hubbleImgSize.height - 10);
        */
        
        UIImage* hubbleImage = [UIImage imageNamed:@"hubble-icon.png"];
        floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [floatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        [floatingButton setImage:hubbleImage forState:UIControlStateNormal];
    }
    return floatingButton;
}

- (void)toggleMenu {
    static int flag = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.6f];
    if (flag == 0) {
        flag = 1;
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.tableView cache:YES];
        self.tableView.alpha = 0.3f;
    } else {
        flag = 0;
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.tableView cache:YES];
        self.tableView.alpha = 1.0f;
    }
    
    [UIView commitAnimations];
}

// fix hubble view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self locateHubbleButton];
}


- (void)locateHubbleButton {
    CGRect tableBounds = self.tableView.bounds;
    
    CGSize hubbleImgSize = floatingMenuBtn.imageView.image.size;
    
    //CGFloat delta = self.tableView.contentOffset.y;
    
    //TODO: 레티나 디스플레이 초기 위치 설정 버그 수정
    CGPoint hubbleImgOrigin = CGPointMake(CGRectGetMaxX(tableBounds) - hubbleImgSize.width - 10,
                                          CGRectGetMaxY(tableBounds) - hubbleImgSize.height - 10);
    floatingMenuBtn.frame = CGRectMake(hubbleImgOrigin.x, hubbleImgOrigin.y, hubbleImgSize.width, hubbleImgSize.height );
}

- (void)printViews {
    NSLog(@"view(%@): %@", self.view, NSStringFromCGRect(self.view.frame));
    NSArray* subviews = self.view.subviews;
    for (UIView* subview in subviews) {
        NSLog(@"- subview: %@", subview);
    }
    
    NSLog(@"tableView(%@): %@", self.tableView, NSStringFromCGRect(self.tableView.frame));
    subviews = self.tableView.subviews;
    for (UIView* subview in subviews) {
        NSLog(@"- subview: %@", subview);
    }
    NSLog(@"scroll: %@", (self.tableView.scrollEnabled?@"enabled":@"disabled"));
    NSLog(@"tableView content size: %@", NSStringFromCGSize(self.tableView.contentSize));
    
}

- (void) organizeToolbar {
    
    UIToolbar* toolbar = (UIToolbar*)[self.view viewWithTag:TAG_TOOLBAR];
    toolbar.items = nil;
    
    // common items 
    NSMutableArray* items = [[NSMutableArray alloc] init];
    NSLog(@"back bar button added");
    UIBarButtonItem* btn = nil;
    btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                        target:nil action:nil];
    [items addObject:btn];
    
    /*
    NSString* returnUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_RETURN_URL];
    if( returnUrl ) {
        btn = [[UIBarButtonItem alloc] initWithTitle:@"웹 화면으로"
                                               style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(finishAndOpenURL:)];
        [items addObject:btn];
    }
    */
    
    btn = [[UIBarButtonItem alloc] initWithTitle:@"종료" 
                                           style:UIBarButtonItemStyleBordered
                                          target:self
                                          action:@selector(finish:)];
    [items addObject:btn];
    btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                        target:nil action:nil];
    [items addObject:btn];
    toolbar.items = items;
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    todoList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end