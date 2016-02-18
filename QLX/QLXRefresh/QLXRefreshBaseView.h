//
//  QLXRefreshBaseView.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/11.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Refresh_ContentSize @"contentSize"
#define Refresh_ContentOffset @"contentOffset"
#define Refresh_State @"state"
#define Refresh_Height 64

/** 刷新控件的状态 */
typedef enum {
    /** 普通闲置状态 */
    QLXRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    QLXRefreshStatePulling,
    /** 正在刷新中的状态 */
    QLXRefreshStateRefreshing,
    /** 即将刷新的状态 */
    QLXRefreshStateWillRefresh
} QLXRefreshState;
/** 进入刷新状态的回调 */

typedef enum {
    QLXRefreshResultNoMoreData = 1,  // 无更多数据
    QLXRefreshResultSuccess,     // 刷新成功
    QLXRefreshResultFail         // 刷新失败
}QLXRefreshResult;  //刷新结果


typedef enum {
    QLXRefreshDirectionVertical, //纵向刷新
    QLXRefreshDirectionHorizonal //横向刷新
}QLXRefreshDirection;  //刷新方向

typedef void (^QLXRefreshingBlock)();

@interface QLXRefreshBaseView : UIView

@property (nonatomic, weak  ) UIScrollView * scrollView; // 父亲
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;
@property (assign, nonatomic) QLXRefreshState state;     // 状态
@property (assign, nonatomic) QLXRefreshResult resultState;     // 刷新结果
@property(nonatomic , assign) QLXRefreshDirection refreshDirection; // 刷新方向 默认纵向
@property (copy, nonatomic  ) QLXRefreshingBlock refreshingBlock;
@property (weak, nonatomic  ) id refreshingTarget;
@property (assign, nonatomic) SEL refreshingAction;
@property (assign, nonatomic) CGFloat pullingPercent;  // 拉拽百分比  [0,1];
@property (assign, nonatomic) CGFloat pullingOffset;   // 拉拽位移
@property (nonatomic, assign) CGFloat viewHeight;      // self  的 高度
@property (nonatomic, assign) CGFloat viewWidth;      // self  的 宽度
@property (nonatomic, strong) UIView * idleView;       // 空闲时的view
@property (nonatomic, strong) UIView * pullingView;    // 松开即可刷新的view
@property (nonatomic, strong) UIView * refreshingView; // 刷新时的view
@property(nonatomic , assign) BOOL animatedEnable;     // 结束刷新是否有动画


- (void)beginRefreshing;

#pragma mark 结束刷新状态
-(void) endRefreshingWithResult:(QLXRefreshResult) result;
-(void) endRefreshingWithResult:(QLXRefreshResult) result animated:(BOOL) animated;

#pragma mark 是否正在刷新
- (BOOL)isRefreshing;


/**
 *  设置刷新 目标 和 函数
 *
 *  @param target
 *  @param action
 */
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;
/**
 *  实行刷新回调函数
 */
-(void)executeRefreshingCallBack;
/**
 *  kvo 监听contentOffset属性的变化
 *
 *  @param change
 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
/**
 *  KVO 监听contentSize属性的变化
 *
 *  @param change
 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;

- (void)scrollViewPanStateDidChange:(NSDictionary *)change;
/**
 *  刷新状态改变回调
 *
 *  @param state
 */
-(void) refreshStateChange:(QLXRefreshState) state;
@end
