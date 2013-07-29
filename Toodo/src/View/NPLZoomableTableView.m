//
//  NPLZoomableTableView.m
//  Toodo
//
//  Created by 1000820 on 12. 6. 22..
//  Copyright (c) 2012년 YakShavingLocus. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NPLZoomableTableView.h"
#import "NPLPannableTableViewCell.h"
#import "NPLTodo.h"             // detach data model(later)
#import "NPLTodoManager.h"
#import "NPLInMemoryTodoList.h"

#define TAG_CACHED_CELL 10000
#define PAN_CLOSED_X 0
#define PAN_OPEN_X -300
#define FAST_ANIMATION_DURATION 0.35
#define SLOW_ANIMATION_DURATION 0.75



@interface NPLZoomableTableView(Private)

// geture recognizer handler

- (IBAction) handlePinchGesture:(UIPinchGestureRecognizer*)recognizer;
- (IBAction) handleTapGesture:(UITapGestureRecognizer*)recognizer;
- (IBAction) handleCellPanning:(UIPanGestureRecognizer*)recognizer;

@end


@implementation NPLZoomableTableView

@synthesize originalFrame;
//@synthesize screenWidth;
//@synthesize screenHeight;

//@synthesize deltaY;
@synthesize prevExpandedCellIndex;


-(void) awakeFromNib {
    // calc pinch-delta size
    
//    CGRect bounds = [[UIScreen mainScreen] bounds];
    
//    self.screenHeight = bounds.size.height;
//    self.screenWidth = bounds.size.width;
//    if (screenWidth > 1000) deltaY = 120; else deltaY =50
    
    [self setMultipleTouchEnabled:NO];
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTapGesture:)];
    [tapRecognizer setDelegate:self];
    [self addGestureRecognizer:tapRecognizer];
}


#pragma mark - Tap Gesture: Zoom a small table view cell to medium size (Update tableview needed)

- (void) closeExpandedCell {
    if (self.prevExpandedCellIndex) {
        NSIndexPath* prevExpandedIndex = self.prevExpandedCellIndex;
        self.prevExpandedCellIndex = nil;
        [self updateCells:[NSArray arrayWithObjects: prevExpandedIndex, nil]];
    }
}

- (void) updateCells:(NSArray*)cells {
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:cells
                withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL shouldStart = YES;
    CGPoint location = [gestureRecognizer locationInView:self];
    NSIndexPath* tappedIndex =[self indexPathForRowAtPoint:location];
    UITableViewCell* tableViewCell =[self cellForRowAtIndexPath:tappedIndex];
    
    //prevent zoom-in on previously panned cell
    if ([tableViewCell isKindOfClass:[NPLPannableTableViewCell class]]) {
        NPLPannableTableViewCell* pannableCell = (NPLPannableTableViewCell*)tableViewCell;
        NPLPannableTableViewCell* prevPannedCell = [pannableCell prevPannedCell];

        if (tableViewCell == prevPannedCell) {
            shouldStart = NO;
        } else {
            [prevPannedCell panClose:YES];
        }
    }
    return shouldStart;
}


// TODO: check if this function called by some methods
- (IBAction) handleTapGesture:(UITapGestureRecognizer*)recognizer {
    static CGPoint startedPos = {0,0};
   
    CGPoint location = [recognizer locationInView:self];
    NSIndexPath* tappedIndex =[self indexPathForRowAtPoint:location];
   
    BOOL shouldZoom = YES;
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:
            startedPos.x = location.x;
            startedPos.y = location.y;
            break;
        case UIGestureRecognizerStateEnded:
            if ( tappedIndex == nil) break;
            if ( self.prevExpandedCellIndex != nil &&
                [self.prevExpandedCellIndex isEqual:tappedIndex] ) {
                
                // zoom out previously zoomed cel;
                self.prevExpandedCellIndex = nil;
                [self updateCells:[NSArray arrayWithObjects:tappedIndex, nil]];
                
            } else if (shouldZoom) {
                
                // zoom in newly tapped cell
                NSIndexPath* indexPath = self.prevExpandedCellIndex;
                self.prevExpandedCellIndex = tappedIndex;
                [self updateCells:[NSArray arrayWithObjects:tappedIndex, indexPath, nil]];
                
                // scroll to
                [self scrollToRowAtIndexPath:tappedIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
            
            break;
        default:
            NSLog(@"not handled tap gesture state in switch %d", [recognizer state]);
            break;
    }
}

#pragma mark - Pinch out: medium size view to detailed view(not decided)

// Pinch Out: change to 'Detail View'
- (IBAction) handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"pinch gesture began");
                        
            NSIndexPath* selectedIndex = [self indexPathForSelectedRow];
//            NSAssertion(selectedIndex != nil,
//                        @"Pinch gesture가 시작되는 시점에는 \
//                        selected index가 존재해야 한다.");
            
            UITableViewCell *cell = [self cellForRowAtIndexPath:selectedIndex];
            
            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
            [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // cache captured cell image
            UIImageView* capturedView = (UIImageView*)[self viewWithTag:TAG_CACHED_CELL];
            if ( !capturedView ){
                capturedView = [[UIImageView alloc] initWithImage:cellImage];
                capturedView.tag = TAG_CACHED_CELL;
                [self addSubview:capturedView];
                CGRect rect = [self rectForRowAtIndexPath:selectedIndex];
                capturedView.frame = CGRectOffset(capturedView.bounds,
                                                  rect.origin.x,
                                                  rect.origin.y);
            }
        } break;
        
        case UIGestureRecognizerStateChanged:
        {
            UIImageView* capturedView =  (UIImageView*)[self viewWithTag:TAG_CACHED_CELL];
            //NSAssert(capturedView != nil,
            //         @"Image should be captured when gesture recognizer began");
            [UIView beginAnimations:@"zoomCell" context:nil];
            capturedView.transform = CGAffineTransformMakeScale(1.1, 2.2);
            //capturedView.center = CGPointMake(self.center.x, location.y);
            
            [UIView commitAnimations];
            
                       
        } break;
        
        case UIGestureRecognizerStateEnded:
        {
            NSLog(@"pinch gesture ended");
            UIImageView* capturedView =  (UIImageView*)[self viewWithTag:TAG_CACHED_CELL];
            [capturedView removeFromSuperview];
         
            //
            
            //TODO: reset previous selected index path to small cell
            /*
            NSIndexPath* selectedIndex = [self indexPathForSelectedRow];
            if (selectedIndex == nil ) break;
            
            NSIndexPath* prevExpandedIndex = self.expandedCellIndex;
            self.expandedCellIndex = selectedIndex;
            
            if ( prevExpandedIndex != nil && prevExpandedIndex.row == selectedIndex.row ) {
                
            } else {
                [self beginUpdates];
                [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects: selectedIndex, prevExpandedIndex, nil] withRowAnimation: UITableViewRowAnimationAutomatic];
                [self endUpdates];
            }
            */
        } break;
            
        default:
            break;
    }
}

@end
