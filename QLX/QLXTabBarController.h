//
//  QLXTabBarController.h
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QLXTabBarControllerDelegate;

@interface QLXTabBarController : UITabBarController

@property(nonatomic , weak) id<QLXTabBarControllerDelegate> tabBarControllerDelegate;
@property(nonatomic , assign) BOOL paddingEnable; // 是否可以滑动分页  默认可以滑动翻页



@end

@protocol QLXTabBarControllerDelegate <UITabBarControllerDelegate>
@optional

/**
 *  滑动分页手势冲突时候可以使用这个代理
 *
 *  @param tabBarController
 *  @param touch
 *
 *  @return 是否接受这个触摸
 */
- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldReciveTouch:(UITouch *)touch;

@end
