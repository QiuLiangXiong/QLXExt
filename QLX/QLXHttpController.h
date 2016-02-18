//
//  QLXHttpController.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/11/9.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXViewController.h"

@interface QLXHttpController : QLXViewController

@property (nonatomic, strong) UIView * firstLoadingView;// 首次加载页面
@property (nonatomic, strong) UIView * noneDataView;    // 无数据页面
@property (nonatomic, strong) UIView * noneNetWorkView; // 无网络页面
@property (nonatomic, strong) UIView * requestErrorView;// 数据加载错误页面
@property (nonatomic, assign) BOOL requesting;    // 请求中

/**
 *  重写
 *
 *  @return 无数据页面
 */
-(UIView *) getNoneDataView;

/**
 *  重写
 *
 *  @return 第一次加载页面
 */

-(UIView *) getFirstLoadingView;

/**
 *  重写
 *
 *  @return 无网络页面
 */
-(UIView *) getNoneNetWorkView;
/**
 *  重写
 *
 *  @return 加载错误页面
 */
-(UIView *) getRequestErrorView;

//第一次加载页面

-(void) showFirstLoadingView;

/**
 *  显示无数据配置好的无数据页面
 */
-(void) showNoneDataView;

/**
 *  显示配置好的无网络页面
 */
-(void) showNoneNetWorkView;

/**
 *  显示配置的请求错误页面
 */

-(void) showRequestErrorView;

/**
 *  显示主页  隐藏其他的一切配置页面
 */
-(void) showMainView;

@end
