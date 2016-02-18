//
//  CALayer+QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/14.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "QLXSpringAnimation.h"
#import "QLXKeyframeAnimation.h"
#import "QLXBasicAnimation.h"

typedef enum : NSUInteger {
    QLXTransitionAnimationNone,
    QLXTransitionAnimationFade,
    QLXTransitionAnimationMoveIn,
    QLXTransitionAnimationPush,
    QLXTransitionAnimationReveal
} QLXTransitionAnimationType;

typedef enum : NSUInteger {
    QLXTransitionAnimationFromDefault,
    QLXTransitionAnimationFromRight,
    QLXTransitionAnimationFromLeft,
    QLXTransitionAnimationFromTop,
    QLXTransitionAnimationFromBottom
} QLXTransitionAnimationSubType;


@interface CALayer(QLXExt)

-(void) addSpringAnimation:(KeyPathType) type  WithBlock:(void(^)(QLXSpringAnimation * animation))block;
-(void) addKeyframeAnimation:(KeyPathType) type  WithBlock:(void(^)(QLXKeyframeAnimation * animation)) block;
-(void) addBasicAnimation:(KeyPathType) type  WithBlock:(void(^)(QLXBasicAnimation * animation)) block;

/**
 *  添加转场动画
 *
 *  @param animationType
 *  @param subType
 *  @param duration
 *
 *  @return
 */
-(CATransition *) addTranstionAnimatinWithType:(QLXTransitionAnimationType )animationType  subTpe:(QLXTransitionAnimationSubType) subType duartion:(CFTimeInterval) duration;
@end
