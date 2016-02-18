//
//  QLXAdPageView.h
//  轮播图 又名 广告图 控件
//
//  Created by QLX on 15/11/1.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXPageView.h"
#import "QLXSegmentControl.h"

@protocol QLXAdPageViewDelegate;
@class QLXPageControl;
@interface QLXAdPageView : UIView

@property(nonatomic , weak) id<QLXAdPageViewDelegate> delegate;

// 默认是系统自带的
@property(nonatomic , strong) UIImage * dotNormalImage;//自定义小圆点 的 正常图片
// 默认是系统自带的
@property(nonatomic , strong) UIImage * dotSelectedImage;//小圆点 的 选中图片


@property(nonatomic , strong) QLXPageControl * pageControl;
@property(nonatomic , assign) BOOL pageDotsHidden;  // 小圆点隐藏  默认不隐藏
@property (nonatomic, assign) BOOL adEnable;  // 自动轮播
@property (nonatomic, assign) NSInteger curPage;   // 当前页   可以设置默认是第一页 设置curpage默认有动画

/**
 *  设置第几页
 *
 *  @param curPage  第几页
 *  @param animated 是否有过渡动画
 */
-(void)setCurPage:(NSInteger)curPage animated:(BOOL) animated;

// 刷新
-(void) reloadData;



//  滚动到下一页
-(void) scrollToNextPage;

// 滚动到上一页
-(void) scrollToLastPage;


@end


// 代理
@protocol QLXAdPageViewDelegate <NSObject>


@required

/**
 *  获取每一页 所需要的数据单元
 *
 *  配置ReuseDataBase派生类 的数组 对应pageCell只能是配置QLXPageViewCell派生类
 *  @param pageView
 *
 *  @return 数组 数组的大小代表有几页
 */
-(NSMutableArray *) pageDataListWithPageView:(QLXAdPageView *)pageView;


@optional
/**
 *  滑动新一页吼
 *
 *  @param newPageIndex  第几页
 */
-(void) adPageView:(QLXAdPageView *)adPageView pageChanged:(NSInteger) pageIndex;


/**
 *  当前页滑到下一页 的百分进度比例
 *
 *  @param value 进度值  [-1,1] 负数代表要滑到上一页  正数代表要滑到下一页
 */
-(void) adPageView:(QLXAdPageView *)adPageView scrollPageProgress:(CGFloat) progress fromPage:(NSInteger)index;




@end