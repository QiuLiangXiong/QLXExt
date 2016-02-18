//
//  QLXViewController.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/15.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLXViewController : UIViewController

@property (nonatomic, strong) UIView * bg; // 做背景


// 通过重写这个方法来设置这个属性
-(UITabBarItem *) getTabBarItem;


@end