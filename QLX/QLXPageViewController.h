//
//  QLXPageViewController.h
//  FunPoint
//
//  Created by QLX on 16/1/10.
//  Copyright © 2016年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXViewController.h"
@protocol QLXPageViewControllerDelegate ;
@interface QLXPageViewController : QLXViewController

@property(nullable, nonatomic,copy) NSArray<__kindof UIViewController *> *viewControllers;
@property(nonatomic , weak) id<QLXPageViewControllerDelegate> delegate;
@property(nonatomic , assign) NSUInteger selectedIndex;

@end


@protocol QLXPageViewControllerDelegate <NSObject>

@optional
/**
 *  滑动新一页吼
 *
 *  @param newPageIndex  第几页
 */
-(void) pageViewController:(nullable QLXPageViewController *)pageViewController pageChanged:(NSInteger) pageIndex;

/**
 *  当前页滑到下一页 的百分进度比例
 *
 *  @param value 进度值  [-1,1] 负数代表要滑到上一页  正数代表要滑到下一页
 */
-(void) pageViewController:(nullable QLXPageViewController *)pageViewController scrollPageProgress:(CGFloat) progress fromPage:(NSInteger)index;

/**
 *  滑动百分比
 *
 *  @param pageView
 *  @param progress [0 ,1];
 */
-(void) pageViewController:(nullable QLXPageViewController *)pageViewController scrollProgress:(CGFloat) progress;

@end