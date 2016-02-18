//
//  QLXRefreshHeaderView.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/11.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXRefreshBaseView.h"

@interface QLXRefreshHeaderView : QLXRefreshBaseView

/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(QLXRefreshingBlock)refreshingBlock;
/** 创建header */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
