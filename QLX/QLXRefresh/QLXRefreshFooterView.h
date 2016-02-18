//
//  QLXRefreshFooterView.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/11.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXRefreshBaseView.h"


@interface QLXRefreshFooterView : QLXRefreshBaseView

@property(nonatomic , assign) CGFloat preRefreshDistance; // 提前刷新距离
@property(nonatomic , strong) UIView * failView;          // 加载失败 的 视图
@property(nonatomic , strong) UIView * noMoreDataView;    // 没有更多数据的视图

/** 创建footer */
+ (instancetype)footerWithRefreshingBlock:(QLXRefreshingBlock)refreshingBlock;
/** 创建footer */
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
