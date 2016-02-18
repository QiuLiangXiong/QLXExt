//
//  QLXNavigationController.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/26.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXNavigationBar.h"
@class QLXViewController;
@protocol  QLXNavigationControllerDelegate;
@interface QLXNavigationController : UINavigationController
@property (nonatomic, weak) UIViewController * barTarget;      // 调用导航栏的对象
@property (nonatomic, assign) BOOL multiNavigationBarEnable;   // 根据背景的不同 智能开启多个不同的导航栏
@property (nonatomic, weak) QLXNavigationController * rootNavigationController;

-(BOOL)getMultiNavigationBarEnable;
/**
 *  设置标题颜色
 *
 *  @param color
 */
-(void) setTitleColor:(UIColor *)color;

/**
 *  设置背景颜色
 *
 *  @param color
 */
-(void) setNavigationBarBgColor:(UIColor *) color;

-(void) setNavigationBarBgImageWithColor:(UIColor *) color;

-(void) setNavigationBarBgImage:(UIImage *) image;
/**
 *  把导航栏下面的线隐藏
 */
-(void) setBarBottomLineHidden;

-(void) setTintColor:(UIColor *) color;

/**
 *  设置默认的导航栏图片
 *
 *  @param image
 */

-(void) setDefaultBarBgWithImage:(UIImage *)image;

/**
 *  退回到 class 的前一个
 *
 *  @param class    类
 *  @param animated 是否有动画
 */

-(NSArray *)popToPreViewControllerWithClass:(Class) class animated:(BOOL)animated;


/**
 *  退回到 class
 *
 *  @param class
 *  @param animated
 */
-(NSArray *)popToViewControllerWithClass:(Class) class animated:(BOOL)animated;
/**
 *  后退几步
 *
 *  @param step
 *  @param animated
 */
-(NSArray *)popToViewControllerWithStep:(NSInteger ) step animated:(BOOL)animated;



/**
 *  获得下一个导航栏控制器
 *
 *  @return
 */

-(QLXNavigationController *)getNextNavigationConroller;

// 用于不同导航栏的背景过度切换
-(void) presentControllerByPushAnimation:(UIViewController *)viewController;

@end


@protocol  QLXNavigationControllerDelegate <UINavigationControllerDelegate>
@optional
-(BOOL)navigationController:(QLXNavigationController *)navigationController canPushViewController:(UIViewController *)viewController animated:(BOOL)animated;

-(BOOL)navigationController:(QLXNavigationController *)navigationController canPopViewControllerAnimated:(BOOL)animated;

-(BOOL)shouldDismissViewController:(QLXNavigationController *)navigationController;

-(UIStatusBarStyle)preferredStatusBarStyle;
@end