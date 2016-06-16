//
//  MHCollectionViewCell.m
//  3D_animation
//
//  Created by CoolKernel on 6/16/16.
//  Copyright © 2016 CoolKernel. All rights reserved.
//

#import "MHCollectionViewCell.h"
#import "MHCubeFlipAnimation.h"

@interface MHCollectionViewCell ()

@property (nonatomic, strong) MHCubeFlipAnimation *horizontalAnimation;
@property (nonatomic, strong) MHCubeFlipAnimation *verticalAnimation;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation MHCollectionViewCell
{
    BOOL rightDirection;
    BOOL leftDirection;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.backgroundColor = [UIColor yellowColor];
        self.label.numberOfLines = 0;
        self.label.text = @"self.label = [[UILabel alloc";
        [self.contentView addSubview:_label];
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
        [self registCubeFlipAction];
    }
    
    return self;
}

- (MHCubeFlipAnimation *)horizontalAnimation
{
    if (!_horizontalAnimation) {
        MHAnimationCarrier *position1 = [[MHAnimationCarrier alloc] initWithParentView:self.imageView position:A];
        MHAnimationCarrier *position2 = [[MHAnimationCarrier alloc] initWithParentView:self.label position:B];
        _horizontalAnimation = [[MHCubeFlipAnimation alloc] init];
        _horizontalAnimation.type = LeftToRight;
        _horizontalAnimation.duration = 0.4;
        _horizontalAnimation.originViewRelative = @[position1, position2];
    }
    
    return _horizontalAnimation;
}

- (MHCubeFlipAnimation *)verticalAnimation
{
    if (!_verticalAnimation) {
        MHAnimationCarrier *position = [[MHAnimationCarrier alloc] initWithParentView:self.imageView position:A];
        _verticalAnimation = [[MHCubeFlipAnimation alloc] init];
        _verticalAnimation.type = LeftToRight;
        _verticalAnimation.values = @[@(35.0f)];
        _verticalAnimation.duration = 0.1;
        _verticalAnimation.originViewRelative = @[position];
    }
    
    return _verticalAnimation;
}

- (void)registCubeFlipAction
{
    UISwipeGestureRecognizer *swipeGestrueDirectionRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeAction:)];
    swipeGestrueDirectionRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeGestrueDirectionRight];
    UISwipeGestureRecognizer *swipeGestureDirectionLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeAction:)];
    swipeGestureDirectionLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeGestureDirectionLeft];
}

- (void)handleSwipeAction:(UISwipeGestureRecognizer *)swipeGestrue
{
    if (swipeGestrue.direction == UISwipeGestureRecognizerDirectionRight) {
        if (rightDirection) { return; }
        [self.horizontalAnimation reset];
        self.horizontalAnimation.values = @[@(30.0f), @(-90.0f)];
        [self.horizontalAnimation startAnimation:^{
        }];
        rightDirection = YES;
    } else if (swipeGestrue.direction == UISwipeGestureRecognizerDirectionLeft && leftDirection == NO && rightDirection == YES) {
        self.horizontalAnimation.values = @[@(0.0f)];
        [self.horizontalAnimation startAnimation:^{
            leftDirection = NO;
            rightDirection = NO;
        }];
        leftDirection = YES;
    }
}

- (void)setData:(NSString *)data
{
    _imageView.image = [UIImage imageNamed:data];
}

@end
