//
//  QLXBasicAnimation.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/17.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIKit/UIKit.h"
#import "QLXSpringAnimation.h"
@class QLXBasicAnimation;
@interface QLXBasicAnimation : CABasicAnimation
@property (nonatomic, weak) UIView * view;     //
@property (nonatomic, copy) AnimationStartClorce animationStart;//
@property (nonatomic, copy) AnimationEndClorce  animationEnd;//
-(void) animationStart:(AnimationStartClorce) startClock;
-(void) animationStop:(AnimationEndClorce) endClock;
+ (instancetype)animationWithKeyPathType:(KeyPathType) type ;
@end
