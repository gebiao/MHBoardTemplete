//
//  MHCollectionViewCell.h
//  3D_animation
//
//  Created by CoolKernel on 6/16/16.
//  Copyright © 2016 CoolKernel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSString *data;

- (void)registCubeFlipAction;

@end
