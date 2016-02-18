//
//  UIScrollView+QLXExt.h
//  
//
//  Created by QLX on 15/9/13.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXRefreshHeaderView.h"
#import "QLXRefreshFooterView.h"

@interface UIScrollView(QLXExt)
@property (assign, nonatomic) CGFloat insetTop;
@property (assign, nonatomic) CGFloat insetBottom;
@property (assign, nonatomic) CGFloat insetLeft;
@property (assign, nonatomic) CGFloat insetRight;

@property (assign, nonatomic) CGFloat offsetX;
@property (assign, nonatomic) CGFloat offsetY;

@property (assign, nonatomic) CGFloat contentW;
@property (assign, nonatomic) CGFloat contentH;

/** 下拉刷新控件 */
@property (strong, nonatomic) QLXRefreshHeaderView * refreshHeader;
/** 上拉刷新控件 */
@property (strong, nonatomic) QLXRefreshFooterView * refreshFooter;

-(void) addRefreshFooterWithTarget:(id)target refreshingAction:(SEL)action;

-(void) addRefreshHeaderWithTarget:(id)target refreshingAction:(SEL)action;

-(void) removeRefreshFooter;

-(void) removeRefreshHeader;

-(void) hideRefreshHeader;

-(void) hideRefreshFooter;

-(void) addRefreshFooterWithTarget:(id)target refreshingAction:(SEL)action footer:(QLXRefreshFooterView *) footer;

-(void) addRefreshHeaderWithTarget:(id)target refreshingAction:(SEL)action header:(QLXRefreshHeaderView *) header;

-(void) headerBeginRefresh;

-(void) footerBeginRefresh;

-(void) headerEndRefreshingWithResult:(QLXRefreshResult) result;

-(void) footerEndRefreshingWithResult:(QLXRefreshResult) result;

-(void) endRefreshingWithResult:(QLXRefreshResult) result;

// 以上为刷新控件扩展

@end
