//
//  QLXPopView.h
//  fcuhConsumer
//  专门用来帮其它视图弹出视图的类  有多种弹出方式 默认有0.5透明度的黑色背景
//  Created by QLX on 16/1/20.
//  Copyright © 2016年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    QLXPopStyleNone,                // 无动画
    QLXPopStyleFade,                // 淡入
    QLXPopStyleScale,               // 从小到大弹出
    QLXPopStyleFromTop,             // 从上弹下来
    QLXPopStyleFromLeft,            // 从左弹出来
    QLXPopStyleFromRight,           // 从右弹出来
    QLXPopStyleFromBottom,          // 从下弹上来
    QLXPopStyleScaleBounces,        // 从小到大弹出 带弹性效果
    QLXPopStyleFromTopBounces,      // 从上弹下来 带弹性效果
    QLXPopStyleFromLeftBounces,     // 从左弹出来 带弹性效果
    QLXPopStyleFromRightBounces,    // 从右弹出来 带弹性效果
    QLXPopStyleFromBottomBounces    // 从下弹上来 带弹性效果
}QLXPopStyle;                       // 弹出方式

@protocol QLXPopViewDelegate;

@interface QLXPopView : UIView

/**
 *  弹出视图调用该类方法
 *
 *  @param rootView 需要被弹出的那个视图
 *  @param view     在哪个视图下弹
 *  @param style    弹出方式
 *  @param block    设置Frame
 */

+(QLXPopView *) popWithRootView:(UIView *) rootView inView:(UIView *)view  withPopStyle:(QLXPopStyle) style makeRootViewFrameWithBlock:(void(^)(UIView * rootView , UIView * superview))block;

+(QLXPopView *) popWithRootView:(UIView *) rootView inView:(UIView *)view withPopStyle:(QLXPopStyle) style backgroundAlpha:(CGFloat)alpha tapBgClose:(BOOL) close  delegate:(id<QLXPopViewDelegate>)delegate makeRootViewFrameWithBlock:(void(^)(UIView * rootView , UIView * superview))block;

/**
 *  视图退出关闭
 *
 *  @param animated 是否有动画
 */
+(void) closeWithRootView:(UIView *)rootView animated:(BOOL) animated;


+(void) closeWithRootView:(UIView *)rootView withAnimationStyle:(QLXPopStyle) style;

@end


@protocol QLXPopViewDelegate <NSObject>

-(void) popView:(QLXPopView *) popView  showAnimationdWillStartWithRootView:(UIView *)rootView;
-(void) popView:(QLXPopView *) popView  showAnimationdDidStartWithRootView:(UIView *)rootView;
-(void) popView:(QLXPopView *) popView  closeAnimationdWillEndWithRootView:(UIView *)rootView;
-(void) popView:(QLXPopView *) popView  closeAnimationdDidEndWithRootView:(UIView *)rootView;

@optional

@end
