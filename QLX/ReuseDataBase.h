//
//  ReuseDataBase.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/10.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIkit.h"
@interface ReuseDataBase : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
/**
 *  高度变化了 请用这个函数调用下
 */
-(void) heightChanged;
/**
 *  由子类重写  必须重写
 *
 *  @return 复用标识 对应的view类名字符串 记得要写对
 */
-(NSString *) reuseIdentifier;


@end
