//
//  UINavigationController+QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/26.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController(QLXExt)

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
 *  @param step     <#step description#>
 *  @param animated <#animated description#>
 */
-(NSArray *)popToViewControllerWithStep:(NSInteger ) step animated:(BOOL)animated;

/**
 *  push 根据 类名  自动 创建对象
 *
 *  @param aClass <#aClass description#>
 */
-(void)pushViewControllerWithClass:(Class) aClass  animated:(BOOL) animated;

/**
 *  为了支持不同导航栏背景的控制器切换效果  提供该方法
 *
 *  @param viewController
 *  @param same        下一个viewcontroller   是否有相同导航栏背景
 */
-(void)pushViewController:(UIViewController *)viewController sameBarBackground:(BOOL)same;



-(void) presentControllerByPushAnimation:(UIViewController *)viewController;
@end
