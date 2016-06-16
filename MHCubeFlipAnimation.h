//
//  MHView.h
//  3D_animation
//
//  Created by CoolKernel on 6/15/16.
//  Copyright © 2016 CoolKernel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MHSolidFlipDirection) {
    LeftToRight = 0,
    TopToBottom,
};

typedef NS_ENUM(NSUInteger, MHRelativePosition) {
    A = 0,  //A面，按逆时针顺序，先横向，再上下
    B,
    C,
    D,
    E,
    F
};

/**
 *  针对长方体视图进行3D翻转
 */
@interface MHCubeFlipAnimation : NSObject
//3d animation direction type, default LeftToRight
@property (nonatomic, assign) MHSolidFlipDirection type;
//many views position relative, [MHAnimationCarrier...]
@property (nonatomic, strong) NSArray *originViewRelative;
//keyframe values, [float]
@property (nonatomic, strong) NSArray *values;
//animation time
@property (nonatomic, assign) float duration;

- (void)startAnimation:(void(^)())finished;

- (void)reset;

@end

@interface MHAnimationCarrier : NSObject

- (instancetype)initWithParentView:(UIView *)parentV position:(MHRelativePosition)position;
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, assign) MHRelativePosition position;
@property (nonatomic, assign) float translateValue;

@end
