//
//  NPLZoomableTableView.h
//  Toodo
//
//  Created by 1000820 on 12. 6. 22..
//  Copyright (c) 2012년 YakShavingLocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPLZoomableTableView : UITableView<UIGestureRecognizerDelegate> {
//	CGFloat screenWidth;
//	CGFloat screenHeight;
    
}

@property (nonatomic, readwrite) CGRect originalFrame;
//@property (nonatomic, readwrite) CGFloat screenWidth;
//@property (nonatomic, readwrite) CGFloat screenHeight;

- (void)updateCells:(NSArray*)cells;

#pragma mark - tap to expand cell
- (void) closeExpandedCell;

#pragma mark - pinch in/out gesture
@property (nonatomic, readwrite) CGFloat deltaY;

#pragma mark - zoom in gesture
@property (nonatomic, readwrite) NSIndexPath* prevExpandedCellIndex;

@end
