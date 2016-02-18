//
//  CALayer+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/14.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "CALayer+QLXExt.h"
#import "QLXExt.h"



@implementation CALayer(QLXExt)
-(void) addSpringAnimation:(KeyPathType) type  WithBlock:(void(^)(QLXSpringAnimation * animation)) block{
    QLXSpringAnimation * animation = [QLXSpringAnimation animationWithKeyPathType:type];
    block(animation);
    [self addAnimation:animation forKey:animation.keyPath];
}

-(void) addKeyframeAnimation:(KeyPathType) type  WithBlock:(void(^)(QLXKeyframeAnimation * animation)) block{
    QLXKeyframeAnimation * animation = [QLXKeyframeAnimation animationWithKeyPathType:type];
    block(animation);
    [self addAnimation:animation forKey:animation.keyPath];
}

-(void) addBasicAnimation:(KeyPathType) type  WithBlock:(void(^)(QLXBasicAnimation * animation)) block{
    QLXBasicAnimation * animation = [QLXBasicAnimation animationWithKeyPathType:type];
    block(animation);
    [self addAnimation:animation forKey:animation.keyPath];
}

-(CATransition *) addTranstionAnimatinWithType:(QLXTransitionAnimationType )animationType  subTpe:(QLXTransitionAnimationSubType) subType duartion:(CFTimeInterval) duration {
    CATransition * animation = [CATransition animation];
    animation.duration = duration;
    animation.type = [self getCAtransitionTypeWithType:animationType];
    NSString * subTypeStr = [self getCAtransitionSubTypeWithType:subType];
    if (![subTypeStr isEqualToString:@""]) {
        animation.subtype = subTypeStr;
    }
    [self addAnimation:animation forKey:@"transition"];
    return animation;
}




-(NSString *)  getCAtransitionTypeWithType:(QLXTransitionAnimationType )animationType{
    switch (animationType) {
        case QLXTransitionAnimationFade:
            return kCATransitionFade;
        case QLXTransitionAnimationPush:
            return kCATransitionPush;
        case QLXTransitionAnimationMoveIn:
            return kCATransitionMoveIn;
        case QLXTransitionAnimationReveal:
            return kCATransitionReveal;
        default:
            break;
    }
    return @"";
}

-(NSString *)  getCAtransitionSubTypeWithType:(QLXTransitionAnimationSubType )animationSubType{
    switch (animationSubType) {
        case QLXTransitionAnimationFromTop:
            return kCATransitionFromTop;
        case QLXTransitionAnimationFromLeft:
            return kCATransitionFromLeft;
        case QLXTransitionAnimationFromRight:
            return kCATransitionFromRight;
        case QLXTransitionAnimationFromBottom:
            return kCATransitionFromBottom;
        default:
            break;
    }
    return @"";
}
@end

