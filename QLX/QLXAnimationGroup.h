//
//  QLXAnimationGroup.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/11/6.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "QLXSpringAnimation.h"

@interface QLXAnimationGroup : CAAnimationGroup

@property (nonatomic, weak) UIView * view;     //
@property (nonatomic, copy) AnimationStartClorce animationStart;//
@property (nonatomic, copy) AnimationEndClorce  animationEnd;//

-(void) animationStart:(AnimationStartClorce) startClock;
-(void) animationStop:(AnimationEndClorce) endClock;

@end
