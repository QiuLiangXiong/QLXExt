//
//  QLXPopView.m
//  fcuhConsumer
//
//  Created by QLX on 16/1/20.
//  Copyright © 2016年 avatar. All rights reserved.
//

#import "QLXPopView.h"
#import "QLXExt.h"

#define kAnimateTime 0.3f
#define kStiffnessValue 300
#define kMassValue 4
#define kDampValue 100

@interface QLXPopView()

@property(nonatomic , weak)  UIView * rootView;
@property(nonatomic , weak)    UIView * showInView;
@property(nonatomic , assign) QLXPopStyle style;
@property(nonatomic , weak) id<QLXPopViewDelegate> delegate;
@property(nonatomic , strong)  QLXView * maskView;



@end

@implementation QLXPopView

+(QLXPopView *) popWithRootView:(UIView *) rootView inView:(UIView *)view  withPopStyle:(QLXPopStyle) style makeRootViewFrameWithBlock:(void(^)(UIView * rootView , UIView * superview))block{
    return [self popWithRootView:rootView inView:view withPopStyle:style backgroundAlpha:0.5 tapBgClose:true delegate:nil makeRootViewFrameWithBlock:block];
}

+(QLXPopView *) popWithRootView:(UIView *) rootView inView:(UIView *)view withPopStyle:(QLXPopStyle) style backgroundAlpha:(CGFloat)alpha tapBgClose:(BOOL) close  delegate:(id<QLXPopViewDelegate>)delegate makeRootViewFrameWithBlock:(void(^)(UIView * rootView , UIView * superview))block{
    return [[self alloc] initWithRootView:rootView inView:view withPopStyle:style backgroundAlpha:alpha tapBgClose:close delegate:delegate makeFrameWithBlock:block];
}

-(instancetype) initWithRootView:(UIView *) rootView inView:(UIView *)view withPopStyle:(QLXPopStyle) style backgroundAlpha:(CGFloat)alpha tapBgClose:(BOOL) close  delegate:(id<QLXPopViewDelegate>)delegate makeFrameWithBlock:(void(^)(UIView * rootView , UIView * superview))block{
    self = [self init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = delegate;
        self.rootView = rootView;
        self.showInView = view;
        [self.showInView addSubview:self];
        [self addSubview:self.rootView];
        block(rootView , self);
        [self showRootViewWithStyle:style alpha:alpha];
        [self constraintWithEdgeZero];
        
        if (close) {
            [self.maskView addTapGestureRecognizerWithTarget:self action:@selector(onClose:)];
        }
    }
    return self;
}

-(QLXView *)maskView{
    if (!_maskView) {
        _maskView = [QLXView createWithBgColor:[UIColor blackColor]];
        _maskView.alpha = 0;
        [self addSubview:_maskView];
        [_maskView sendToBack];
        [_maskView constraintWithEdgeZero];
    }
    return _maskView;
}

-(void) onClose:(UIGestureRecognizer *) gesture{
    [QLXPopView closeWithRootView:self.rootView animated:true];
}

+(void) closeWithRootView:(UIView *)rootView animated:(BOOL) animated{
    
    QLXPopView * popView = (QLXPopView *)rootView.superview;
    
    if ([popView isKindOfClass:[QLXPopView class]]) {
        if ([popView.delegate respondsToSelector:@selector(popView:closeAnimationdWillEndWithRootView:)]) {
            [popView.delegate popView:popView closeAnimationdWillEndWithRootView:popView.rootView];
        }
        
        if (animated) {
            [popView hideRootView];
            popView.showInView.userInteractionEnabled = false;
            [UIView animateWithDuration:kAnimateTime animations:^{
                popView.maskView.alpha = 0;
            } completion:^(BOOL finished) {
                if ([popView.delegate respondsToSelector:@selector(popView:closeAnimationdDidEndWithRootView:)]) {
                    [popView.delegate popView:popView closeAnimationdDidEndWithRootView:popView.rootView];
                }
                popView.showInView.userInteractionEnabled = true;
                [popView removeFromSuperview];
            }];
        }else {
            [popView removeFromSuperview];
        }
    }
}


+(void) closeWithRootView:(UIView *)rootView withAnimationStyle:(QLXPopStyle) style{
    QLXPopView * popView = (QLXPopView *)rootView.superview;
    popView.style = style;
    BOOL animated = style != QLXPopStyleNone;
    [self closeWithRootView:rootView animated:animated];
}

-(void) showMaskViewWithAlpha:(CGFloat) alpha{
    kBlockWeakSelf;
    if ([self.delegate respondsToSelector:@selector(popView:showAnimationdWillStartWithRootView:)]) {
        [self.delegate popView:self showAnimationdWillStartWithRootView:self.rootView];
    }
    if (self.style != QLXPopStyleNone) {
        self.showInView.userInteractionEnabled = false;
        [UIView animateWithDuration:kAnimateTime animations:^{
            weakSelf.maskView.alpha = alpha;
        } completion:^(BOOL finished) {
            if ([weakSelf.delegate respondsToSelector:@selector(popView:showAnimationdDidStartWithRootView:)]) {
                [weakSelf.delegate popView:weakSelf showAnimationdDidStartWithRootView:weakSelf.rootView];
            }
            weakSelf.showInView.userInteractionEnabled = true;
        }];
    }else {
        self.maskView.alpha = alpha;
    }
    
}

-(void) hideRootView{
    switch (self.style) {
        case QLXPopStyleNone:
        {
            self.hidden = true;
            break;
        }
        case QLXPopStyleFade:
        {
            [self hideRootViewByFade];
            break;
        }
        case QLXPopStyleScale:
        {
            [self hideRootViewByScale];
            break;
        }
        case QLXPopStyleFromTop:
        {
            [self hideRootViewByFromBottom];
            break;
        }
        case QLXPopStyleFromLeft:
        {
            [self hideRootViewByFromRight];
            break;
        }
        case QLXPopStyleFromRight:
        {
            [self hideRootViewByFromLeft];
            break;
        }
        case QLXPopStyleFromBottom:
        {
            [self hideRootViewByFromTop];
            break;
        }
        case QLXPopStyleScaleBounces:
        {
            [self hideRootViewByScale];
            break;
        }
        case QLXPopStyleFromTopBounces:
        {
            [self hideRootViewByFromBottom];
            break;
        }
        case QLXPopStyleFromLeftBounces:
        {
            [self hideRootViewByFromRight];
            break;
        }
        case QLXPopStyleFromRightBounces:
        {
            [self hideRootViewByFromLeft];
            break;
        }
        case QLXPopStyleFromBottomBounces:
        {
            [self hideRootViewByFromTop];
            break;
        }
            
            
        default:
            break;
    }
    
}

-(void)  showRootViewWithStyle:(QLXPopStyle) style alpha:(CGFloat) alpha{
    self.style = style;
    [self showMaskViewWithAlpha:alpha];
    switch (self.style) {
        case QLXPopStyleNone:
        {
            break;
        }
        case QLXPopStyleFade:
        {
            [self showRootViewByFade];
            break;
        }
        case QLXPopStyleScale:
        {
            [self showRootViewByScale];
            break;
        }
        case QLXPopStyleFromTop:
        {
            [self showRootViewByFromTop];
            break;
        }
        case QLXPopStyleFromLeft:
        {
            [self showRootViewByFromLeft];
            break;
        }
        case QLXPopStyleFromRight:
        {
            [self showRootViewByFromRight];
            break;
        }
        case QLXPopStyleFromBottom:
        {
            [self showRootViewByFromBottom];
            break;
        }
        case QLXPopStyleScaleBounces:
        {
            [self showRootViewByScaleBounces];
            break;
        }
        case QLXPopStyleFromTopBounces:
        {
            [self showRootViewByFromTopBounces];
            break;
        }
        case QLXPopStyleFromLeftBounces:
        {
            [self showRootViewByFromLeftBounces];
            break;
        }
        case QLXPopStyleFromRightBounces:
        {
            [self showRootViewByFromRightBounces];
            break;
        }
        case QLXPopStyleFromBottomBounces:
        {
            [self showRootViewByFromBottomBounces];
            break;
        }
        default:
            break;
    }
}


// show

-(void) showRootViewByFade{
    kBlockWeakSelf;
    self.rootView.alpha = 0;
    [UIView animateWithDuration:kAnimateTime animations:^{
        weakSelf.rootView.alpha = 1;
    }];
}

-(void) showRootViewByScale{
    [self.rootView.layer addSpringAnimation:KeyPathTypeTransformScale WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(0);
        animation.toValue = @(1);
        animation.damping = kDampValue;
        animation.stiffness = kStiffnessValue;
        animation.mass = kMassValue;
    }];
}

-(void) showRootViewByFromTop{
    [self.rootView.layer addSpringAnimation:(KeyPathTypePositionY) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(-kScreenHeight);
        animation.toValue = @(0);
        animation.additive = true;
        animation.damping = kDampValue;
        animation.stiffness = kStiffnessValue;
        animation.mass = kMassValue;
    }];
}

-(void) showRootViewByFromBottom{
    [self.rootView.layer addSpringAnimation:(KeyPathTypePositionY) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(kScreenHeight);
        animation.toValue = @(0);
        animation.additive = true;
        animation.damping = kDampValue;
        animation.stiffness = kStiffnessValue;
        animation.mass = kMassValue;
    }];
    
}

-(void) showRootViewByFromLeft{
    [self.rootView.layer addSpringAnimation:(KeyPathTypePositionX) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(-kScreenHeight);
        animation.toValue = @(0);
        animation.additive = true;
        animation.damping = kDampValue;
        animation.stiffness = kStiffnessValue;
        animation.mass = kMassValue;
    }];
}

-(void) showRootViewByFromRight{
    [self.rootView.layer addSpringAnimation:(KeyPathTypePositionX) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(kScreenHeight);
        animation.toValue = @(0);
        animation.additive = true;
        animation.damping = kDampValue;
        animation.stiffness = kStiffnessValue;
        animation.mass = kMassValue;
    }];
}


// hide

-(void) hideRootViewByFade{
    kBlockWeakSelf;
    [UIView animateWithDuration:kAnimateTime animations:^{
        weakSelf.rootView.alpha = 0;
    }];
}

-(void) hideRootViewByScale{
    [self.rootView animateWithFromScale:1 toScale:0];
}

-(void) hideRootViewByFromTop{
    [self.rootView.layer addSpringAnimation:(KeyPathTypePositionY) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(0);
        animation.toValue = @(-kScreenHeight);
        animation.additive = true;
        animation.damping = 100;
        animation.mass = 15;
    }];
}

-(void) hideRootViewByFromBottom{
    [self.rootView.layer addSpringAnimation:(KeyPathTypePositionY) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(0);
        animation.toValue = @(kScreenHeight);
        animation.additive = true;
        animation.damping = 100;
        animation.mass = 15;
    }];
}

-(void) hideRootViewByFromLeft{
    [self.rootView.layer addSpringAnimation:(KeyPathTypePositionX) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(0);
        animation.toValue = @(-kScreenHeight);
        animation.additive = true;
        animation.damping = 100;
        animation.mass = 15;
    }];
}

-(void) hideRootViewByFromRight{
    [self.rootView.layer addSpringAnimation:(KeyPathTypePositionX) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(0);
        animation.toValue = @(kScreenHeight);
        animation.additive = true;
        animation.damping = 100;
        animation.mass = 15;
    }];
}



// show bounces



-(void) showRootViewByScaleBounces{
    [self.rootView.layer addSpringAnimation:KeyPathTypeTransformScale WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(0);
        animation.toValue = @(1);
        animation.damping = 51.21;
        animation.stiffness = 500;
        animation.mass = 3.48;
    }];
}

-(void) showRootViewByFromTopBounces{
    [self.rootView.layer addSpringAnimation:(KeyPathTypePositionY) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(-kScreenHeight);
        animation.toValue = @(0);
        animation.additive = true;
        animation.damping = 51.21;
        animation.stiffness = 500;
        animation.mass = 3.48;
    }];
}

-(void) showRootViewByFromBottomBounces{
    [self.rootView.layer addSpringAnimation:(KeyPathTypePositionY) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(kScreenHeight);
        animation.toValue = @(0);
        animation.additive = true;
        animation.damping = 51.21;
        animation.stiffness = 500;
        animation.mass = 3.48;
    }];
}

-(void) showRootViewByFromLeftBounces{
    [self.rootView.layer addSpringAnimation:(KeyPathTypePositionX) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(-kScreenWidth);
        animation.toValue = @(0);
        animation.additive = true;
        animation.damping = 51.21;
        animation.stiffness = 500;
        animation.mass = 3.48;
    }];
}

-(void) showRootViewByFromRightBounces{
    [self.rootView.layer addSpringAnimation:(KeyPathTypePositionX) WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(kScreenWidth);
        animation.toValue = @(0);
        animation.additive = true;
        animation.damping = 51.21;
        animation.stiffness = 500;
        animation.mass = 3.48;
    }];
}



@end
