//
//  QLXVCTransitionPushAnimator.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/10/10.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXVCTransitionPushAnimator.h"
#import "QLXExt.h"
@implementation QLXVCTransitionPushAnimator

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
    if (transitionContext.isInteractive) {
        [self interactionPopAmimation:transitionContext];
    }else if(self.isDimiss == false){
        [self pushAnimation:transitionContext];
    }else if(self.isDimiss){
        [self dismissAnimation:transitionContext];
    }
}

/**
 *  手势返回动画
 *
 *  @param transitionContext
 */
-(void) interactionPopAmimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    CGRect startFrame = self.containerView.bounds;
    startFrame.origin.x = startFrame.size.width;
    CGRect endFrame = self.containerView.bounds;

    [self.containerView addSubview:self.toViewController.view];
    [self.toViewController.view sendToBack];
    kBlockWeakSelf;
    self.toViewController.view.alpha = 1.0f;
    self.toViewController.view.x = - endFrame.size.width / 3;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]  animations:^{
        weakSelf.fromViewController.view.frame = startFrame;
        weakSelf.toViewController.view.frame = endFrame;
        weakSelf.toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        weakSelf.toViewController.view.alpha = 1;
        [GCDQueue executeInMainQueue:^{
           [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        } afterDelaySecs:0.02];
    }];
}


// removes all the views other than the given view from the superview
- (void)removeOtherViews:(UIView*)viewToKeep {
    UIView* containerView = viewToKeep.superview;
    for (UIView* view in containerView.subviews) {
        if (view != viewToKeep) {
            [view removeFromSuperview];
        }
    }
}

/**
 *  push 动画
 *
 *  @param transitionContext
 */
-(void) pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    CGRect startFrame = self.containerView.bounds;
    startFrame.origin.x = startFrame.size.width;
    CGRect endFrame = self.containerView.bounds;
    [self.containerView addSubview:self.toViewController.view];
    self.toViewController.view.frame = endFrame;
    __weak typeof(&*transitionContext) temptransitionContext = transitionContext;
    [self.toViewController.view.layer addSpringAnimation:(KeyPathTypePositionX) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(endFrame.size.width * 1.5);
        animation.toValue = @(endFrame.size.width *0.5);
        animation.damping = 92.16;
        animation.mass = 3;
        [animation animationStop:^(CAAnimation *anim, BOOL finished) {
            [temptransitionContext completeTransition:![temptransitionContext transitionWasCancelled]];
        }];
    }];
    endFrame.origin.x = - endFrame.size.width / 3;
    self.fromViewController.view.frame = endFrame;
    [self.fromViewController.view.layer addBasicAnimation:(KeyPathTypePositionX) WithBlock:^(QLXBasicAnimation *animation) {
        animation.duration = 0.3;
        animation.fromValue = @(endFrame.size.width / 2);
        animation.toValue = @(endFrame.origin.x + endFrame.size.width / 2);
        
    }];
}

/**
 *  返回退出动画
 *
 *  @param transitionContext
 */
-(void) dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    CGRect startFrame = self.containerView.bounds;
    startFrame.origin.x = startFrame.size.width;
    CGRect endFrame = self.containerView.bounds;
    //self.ViewController.view.frame = endFrame;
    [self.containerView addSubview:self.toViewController.view];
    [self.toViewController.view sendToBack];
    self.fromViewController.view.frame = startFrame;
    __weak typeof(&*transitionContext) temptransitionContext = transitionContext;
    [self.fromViewController.view.layer addSpringAnimation:(KeyPathTypePositionX) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(endFrame.size.width / 2);
        animation.toValue = @(endFrame.size.width * 1.5);
        animation.damping = 92.16;
        animation.mass = 3;
        [animation animationStop:^(CAAnimation *anim, BOOL finished) {
            [temptransitionContext completeTransition:![temptransitionContext transitionWasCancelled]];
        }];
    }];
    self.toViewController.view.frame = endFrame;
    [self.toViewController.view.layer addSpringAnimation:(KeyPathTypePositionX) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue =  @(- endFrame.size.width / 3 + endFrame.size.width /2);
        animation.toValue = @(endFrame.size.width / 2);
        animation.damping = 92.16;
        animation.mass = 3;
    }];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([self.destinationController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * naVC = (UINavigationController *)self.destinationController;
        return naVC.viewControllers.count == 1 && naVC.presentedViewController == nil;
    }
    return false;
}

@end
