//
//  QLXTarbarVCTransitionPaddingAnimator.h
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXVCTransitionAnimatorBase.h"

@class QLXPanGestureRecognizer;

@protocol QLXTarbarVCTransitionPaddingAnimatorDelegate;

@interface QLXTarbarVCTransitionPaddingAnimator : QLXVCTransitionAnimatorBase<UITabBarControllerDelegate>

@property(nonatomic , weak) id<QLXTarbarVCTransitionPaddingAnimatorDelegate> delegate;


@end

@protocol QLXTarbarVCTransitionPaddingAnimatorDelegate <NSObject>

@optional
/**
 *  是否接受本次触摸 （一般用于解决手势冲突）
 *
 *  @param animator
 *  @param gestureRecognizer
 *  @param velocity          拖动手势的初始化加速度 可以用来判断方向
 *
 *  @return 是否接受本次触摸
 */

- (BOOL)animator:(QLXTarbarVCTransitionPaddingAnimator *)animator gestureRecognizer:(QLXPanGestureRecognizer *)gestureRecognizer shouldBeginWithVelocity:(CGPoint) velocity;

@end