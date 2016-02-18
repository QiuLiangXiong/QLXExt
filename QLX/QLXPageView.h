//
//  QLXPageView.h
//  QLXExtDemo
//
//  Created by QLX on 15/10/29.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXView.h"
#import "QLXCollectionView.h"
#import "QLXPageViewCell.h"

@protocol QLXPageViewDelegate;

@interface QLXPageView : QLXView

@property (nonatomic, assign) NSInteger curPage;   // 当前页
@property (nonatomic, weak) id<QLXPageViewDelegate> pageViewDelegate;
@property (nonatomic, assign) BOOL adEnable;   // 是否轮播
@property (nonatomic, assign) BOOL tracking;
@property (nonatomic, assign) BOOL decelerating;
@property(nonatomic , strong) QLXCollectionView * collectionView;


// 刷新某一页   // 尽量用这个刷新 如果不是当前页就不刷新了
-(void) reloadDataWithPageIndex:(NSInteger)index;

// 刷新  // 会刷新当前页的显示
-(void) reloadData;


// 改变当前页面 animated  是否有滚动动画
-(void)setCurPage:(NSInteger)curPage animated:(BOOL) animated;

@end



// 代理
@protocol QLXPageViewDelegate <UIScrollViewDelegate , QLXPageViewCellDelegate>

@required
/**
 *  获取每一页 所需要的数据单元
 *
 *  配置ReuseDataBase派生类 的数组 对应pageCell只能是配置QLXPageViewCell派生类
 *  @param pageView
 *
 *  @return 数组 数组的大小代表有几页
 */

-(NSMutableArray *) pageDataListWithPageView:(QLXPageView *)pageView;

@optional
/**
 *  滑动新一页吼
 *
 *  @param newPageIndex  第几页
 */
-(void) pageView:(QLXPageView *)pageView pageChanged:(NSInteger) pageIndex;

/**
 *  当前页滑到下一页 的百分进度比例
 *
 *  @param value 进度值  [-1,1] 负数代表要滑到上一页  正数代表要滑到下一页
 */
-(void) pageView:(QLXPageView *)pageView scrollPageProgress:(CGFloat) progress fromPage:(NSInteger)index;

/**
 *  滑动百分比
 *
 *  @param pageView
 *  @param progress [0 ,1];
 */
-(void) pageView:(QLXPageView *)pageView scrollProgress:(CGFloat) progress;

/**
 *  点击了第几页
 *
 *  @param pageView
 *  @param index    第几页
 */
-(void) pageView:(QLXPageView *)pageView didSelectPageAtIndex:(NSInteger)index;

@end