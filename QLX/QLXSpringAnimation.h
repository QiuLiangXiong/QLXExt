//
//  QLXSpringAnimation.h
//
//
//  Created by 邱良雄 on 15/8/15.
//  Copyright (c) 2015年 avatar. All rights reserved.
//
// Adds the ability to add spring to your animations.
//
// Duration cannot be set directly. Instead, duration is
// a side effect of changing the various properties below.
//
// Although QLXSpringAnimation is a subclass of CAKeyframeAnimation,
// it should be treated as if it were a subclass of CABasicAnimation.

#import "JNWSpringAnimation.h"
#import "UIKit/UIKit.h"
typedef enum{
    KeyPathTypePositionX,
    KeyPathTypePositionY,
    KeyPathTypePosition,
    KeyPathTypeCornerRadius,
    KeyPathTypeTransformScale,
    KeyPathTypeTransformRotationZ,
    KeyPathTypeTransformRotationX,

    KeyPathTypeTransformRotationY,

    KeyPathTypeBounds,
    KeyPathTypeTransform,
    KeyPathTypeOpacity,
    KeyPathTypeBackgroundColor,
    KeyPathTypeBorderWidth,
    KeyPathTypeFrame,
    KeyPathTypeHidden,
    KeyPathTypeMask,
    KeyPathTypeMasksToBounds,
    KeyPathTypeShadowColor,
    KeyPathTypeShadowOffset,
    KeyPathTypeShadowOpacity,
    KeyPathTypeShadowRadius
}KeyPathType;
@class QLXSpringAnimation;
typedef void(^AnimationStartClorce)(CAAnimation * anim );
typedef void(^AnimationEndClorce)(CAAnimation * anim , BOOL finished);

@interface QLXSpringAnimation : JNWSpringAnimation

@property (nonatomic, weak) UIView * view;     //
@property (nonatomic, copy) AnimationStartClorce animationStart;//
@property (nonatomic, copy) AnimationEndClorce  animationEnd;//

-(void) animationStart:(AnimationStartClorce) startClock;

-(void) animationStop:(AnimationEndClorce) endClock;

+ (instancetype)animationWithKeyPathType:(KeyPathType) type ;

@end
