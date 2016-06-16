//
//  MHCollectionView.m
//  3D_animation
//
//  Created by CoolKernel on 6/16/16.
//  Copyright © 2016 CoolKernel. All rights reserved.
//

#import "MHCollectionView.h"

@implementation MHCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
    }
    
    return self;
}

- (void)registerMoveAction
{
    static UILongPressGestureRecognizer *panGesture = nil;
    panGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self addGestureRecognizer:panGesture];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    static NSIndexPath *originIndexPath = nil;
    static UIView *snapView = nil;
    CGPoint currentLocation = [longPressGesture locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:currentLocation];

    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        if (!indexPath) { return; }
        originIndexPath = indexPath;
        //begin cell
        UICollectionViewCell *originCell = [self cellForItemAtIndexPath:indexPath];
        //pan display current cell snap view
        snapView = [self generatorSnapView:originCell];
        __block CGPoint center = originCell.center;
        snapView.center = center;
        [UIView animateWithDuration:0.25 animations:^{
            center.y = currentLocation.y;
            snapView.center = center;
            [self addSubview:snapView];
            originCell.hidden = YES;
        }];
    } else if (longPressGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint center = snapView.center;
        center = currentLocation;
        snapView.center = center;
        //move process cell
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
        BOOL isEqual = [self comparePoint:center target:cell.center];
        //first: judge is suuport kinds
        if (indexPath && ![indexPath isEqual:originIndexPath] && isEqual) {
            
        }
        
        if (indexPath && ![indexPath isEqual:originIndexPath]) {
            //datasource exchange
            if (self.dataSourceArr) {
                [self.dataSourceArr exchangeObjectAtIndex:originIndexPath.row withObjectAtIndex:indexPath.row];
            }
            //UI move
            [self moveItemAtIndexPath:originIndexPath toIndexPath:indexPath];
            originIndexPath = indexPath;
        }
    } else {
        //target cell
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
        [UIView animateWithDuration:0.2f animations:^{
            snapView.center = cell.center;
            snapView.transform = CGAffineTransformIdentity;
            snapView.alpha = 0.5;
        } completion:^(BOOL finished) {
            [snapView removeFromSuperview];
            cell.hidden = NO;
        }];
        originIndexPath = nil;
    }
}

- (BOOL)comparePoint:(CGPoint)origin target:(CGPoint)target
{
    if (fabs(origin.x - target.x) < 5 && fabs(origin.y - target.y) < 5) {
        return YES;
    }
    return NO;
}

- (UIView *)generatorSnapView:(UIView *)originView
{
    UIView *snap = [originView snapshotViewAfterScreenUpdates:YES];
    snap.alpha = 0.8;
    CGAffineTransformScale(snap.transform, 0.95, 0.95);
    
    return snap;
}

@end
