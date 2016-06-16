//
//  MHCollectionView.h
//  3D_animation
//
//  Created by CoolKernel on 6/16/16.
//  Copyright © 2016 CoolKernel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHCollectionView : UICollectionView
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

//must regist this method, can support item move and group
- (void)registerMoveAction;


@end
