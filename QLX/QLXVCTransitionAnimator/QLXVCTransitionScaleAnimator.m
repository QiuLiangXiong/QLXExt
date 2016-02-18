//
//  QLXVCTransitionScaleAnimator.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/11/7.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXVCTransitionScaleAnimator.h"
#import "QLXExt.h"

@implementation QLXVCTransitionScaleAnimator

/**
 *  动画时间
 *
 *  @param transitionContext
 */
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.501f;
}

/**
 *  动画都是在这里做的
 *
 *  @param transitionContext
 */
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    [super animateTransition:transitionContext];
//    if (transitionContext.isInteractive) {
//        [self interactionPopAmimation:transitionContext];
   if(self.isDimiss == false){
        [self presentAnimation:transitionContext];
    }else if(self.isDimiss){
       [self dismissAnimation:transitionContext];
    }
}


-(void) presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    CGRect startFrame = self.containerView.bounds;
    startFrame.origin.x = startFrame.size.width;
    CGRect endFrame = self.containerView.bounds;
    [self.containerView addSubview:self.toViewController.view];
    self.toViewController.view.frame = endFrame;
    __weak typeof(&*transitionContext) temptransitionContext = transitionContext;
    [self.toViewController.view.layer addSpringAnimation:(KeyPathTypeTransformScale) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(0);
        animation.toValue = @(1);
        animation.damping = 60;
        [animation animationStop:^(CAAnimation *anim, BOOL finished) {
            [temptransitionContext completeTransition:![temptransitionContext transitionWasCancelled]];
        }];
    }];

}

-(void) dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    CGRect startFrame = self.containerView.bounds;
    startFrame.origin.x = startFrame.size.width;
    CGRect endFrame = self.containerView.bounds;
    [self.containerView addSubview:self.toViewController.view];
    [self.toViewController.view sendToBack];
    self.toViewController.view.frame = endFrame;
    __weak typeof(&*transitionContext) temptransitionContext = transitionContext;
    [self.fromViewController.view.layer addSpringAnimation:(KeyPathTypeTransformScale) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(1);
        animation.toValue = @(0);
        animation.damping = 100;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = false;
        [animation animationStop:^(CAAnimation *anim, BOOL finished) {
            [temptransitionContext completeTransition:![temptransitionContext transitionWasCancelled]];
        }];
    }];

}

@end
