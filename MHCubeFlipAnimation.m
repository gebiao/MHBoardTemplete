//
//  MHView.m
//  3D_animation
//
//  Created by CoolKernel on 6/15/16.
//  Copyright © 2016 CoolKernel. All rights reserved.
//
#import "MHCubeFlipAnimation.h"

#define degToRad(x) (M_PI * (x) / 180.0)
#define perAngle (3)

@interface MHCubeFlipAnimation ()
@property (nonatomic, copy) void (^callback)(NSInteger);
@property (nonatomic, assign) NSInteger currRepeteIndex;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) float lastAngle;
@property (nonatomic, assign) float totalPath;
@property (nonatomic, copy) void(^finisedCallback)();

@end

@implementation MHCubeFlipAnimation

+ (void)initialize {
    MHCubeFlipAnimation *animationObj = [[MHCubeFlipAnimation alloc] init];
    animationObj.currRepeteIndex = 0;
    animationObj.index = 0;
    animationObj.lastAngle = 0.0f;
    animationObj.totalPath = 0.0f;
}

- (void)setOriginViewRelative:(NSArray *)originViewRelative
{
    _originViewRelative = originViewRelative;
    [self updateParaments];
}

- (void)setType:(MHSolidFlipDirection)type
{
    _type = type;
    [self updateParaments];
}

- (float)getValue:(UIView *)view
{
    switch (_type) {
        case LeftToRight:
            return  view.frame.size.width / 2;
            break;
            case TopToBottom:
            return  view.frame.size.height / 2;
            break;
        default:
            break;
    }
}

- (void)updateParaments
{
    for (MHAnimationCarrier *carrier in _originViewRelative) {
        float startAngle = 0;
        switch (carrier.position) {
            case A:
                startAngle = 0;
                break;
            case B:
                startAngle = 90;
                break;
            case C:
                startAngle = 180;
                break;
            case D:
                startAngle = -90;
                break;
            case E:
                startAngle = 90;
                break;
            case F:
                startAngle = -90;
                break;
            default:
                break;
        }
        carrier.translateValue = [self getValue:carrier.parentView];
        carrier.parentView.layer.transform = [self generatorTransform:startAngle translateValue:carrier.translateValue];
    }
}

- (void)setValues:(NSArray *)values
{
    _values = values;
    float last = 0;
    for (NSNumber *angle in values) {
        float angleV = [angle floatValue];
        self.totalPath += fabsf(angleV - last);
        last = angleV;
    }
}

- (void)startAnimation:(void(^)())finished
{
    self.finisedCallback = finished;
    [self keyFrameAnimation];
}

- (void)reset
{
    self.currRepeteIndex = 0;
    self.index = 0;
    self.lastAngle = 0.0f;
    self.totalPath = 0.0f;
    for (MHAnimationCarrier *carrier in _originViewRelative) {
        carrier.parentView.layer.transform = CATransform3DIdentity;
    }
}

- (void)keyFrameAnimation
{
    _index = 0;
    __weak typeof(self)weakself = self;
    [self setCallback:^(NSInteger indexp) {
        weakself.currRepeteIndex = 0;
        if (indexp < weakself.values.count) {
            float value = [weakself.values[indexp] floatValue];
            float d = fabs(value - weakself.lastAngle) / weakself.totalPath * weakself.duration;
            if (d > 0) {
                [weakself manageAnimation:value duration:d];
            }
        } else {
            if (weakself.finisedCallback) {
                weakself.finisedCallback();
            }
        }
    }];
    self.callback(_index);
}

- (CATransform3D)generatorTransform:(float)value translateValue:(float)translateValue
{
    //Create the Matrix identity
    CATransform3D t = CATransform3DIdentity;
    //Setup the perspective modifying the matrix elementat [3][4]
    t.m34 = 1.0f / - 5000.0f;
    switch (self.type) {
        case LeftToRight: {
            //Perform rotate on the matrix identity
            t = CATransform3DRotate(t, degToRad(value), 0.0f, 1.0f, 0.0f);
            //Perform translate on the current transform matrix (identity + rotate)
            t = CATransform3DTranslate(t, 0.0f, 0.0f,  translateValue);
        }
            break;
        case TopToBottom: {
            //Perform rotate on the matrix identity
            t = CATransform3DRotate(t, degToRad(value), 1.0f, 0.0f, 0.0f);
            //Perform translate on the current transform matrix (identity + rotate)
            t = CATransform3DTranslate(t, 0.0f, 0.0f,  translateValue);
        }
            break;
        default:
            break;
    }
    [CATransaction setAnimationDuration:0.0f];
    
    return t;
}

- (void)manageAnimation:(float)angleV duration:(float)duration
{
    NSInteger count = fabs((angleV - _lastAngle) / perAngle);
    float perTime = duration / count;
    NSTimer *timer = [NSTimer timerWithTimeInterval:perTime target:self selector:@selector(handleAnimation:) userInfo:@{@"count" : @(count), @"clockwise" : @((angleV - _lastAngle) > 0 ? YES : NO)} repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)handleAnimation:(NSTimer *)timer
{
    _currRepeteIndex ++;
    
    NSInteger count = [timer.userInfo[@"count"] longValue];
    BOOL iswise = [timer.userInfo[@"clockwise"] boolValue];
    float value = _currRepeteIndex * perAngle;
    value = (iswise ? value : value * (-1));
    value += _lastAngle;
    for (MHAnimationCarrier *carrier in self.originViewRelative) {
        switch (carrier.position) {
            case A:
                carrier.parentView.layer.transform = [self generatorTransform:value translateValue:carrier.translateValue];
                break;
            case B:
                carrier.parentView.layer.transform = [self generatorTransform:value + 90 translateValue:carrier.translateValue];
                break;
            case C:
                carrier.parentView.layer.transform = [self generatorTransform:value + 180 translateValue:carrier.translateValue];
                break;
            case D:
                carrier.parentView.layer.transform = [self generatorTransform:value - 90 translateValue:carrier.translateValue];
                break;
            case E:
                carrier.parentView.layer.transform = [self generatorTransform:value + 90 translateValue:carrier.translateValue];
                break;
            case F:
                carrier.parentView.layer.transform = [self generatorTransform:value - 90 translateValue:carrier.translateValue];
                break;
            default:
                break;
        }
    }

    if (_currRepeteIndex > count) {
        [timer invalidate];
        if (self.callback) {
            _index ++;
            _lastAngle = value;
            self.callback(_index);
        }
    }
}


@end

@implementation MHAnimationCarrier

- (instancetype)initWithParentView:(UIView *)parentV position:(MHRelativePosition)position
{
    if (self = [super init]) {
        self.parentView = parentV;
        self.position = position;
    }
    
    return self;
}

@end




















