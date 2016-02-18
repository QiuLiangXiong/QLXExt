//
//  QLXTimer.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/21.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

/**
 *  都是循环的 timer  具有自动移除功能
 */
#import <Foundation/Foundation.h>
#import "YXGCD.h"
@interface QLXTimer : GCDTimer

+ (instancetype) getInstance;

// 删除关于这个对象 添加的 定时器
-(void) removeWithTarget:(id)target;
/**
 *  自动移除 的方法
 *
 *  @param ti        时间间隔
 *  @param aTarget   target
 *  @param aSelector 方法
 *  @param userInfo  参数
 *  @param start     是否马上执行
 *
 *  @return timer 实例
 */
+ (QLXTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo nowStart:(BOOL) start;

/**
 *  不参与自动移除
 *
 *  @param ti
 *  @param aTarget
 *  @param aSelector
 *  @param userInfo
 *  @param start
 *
 *  @return
 */

- (QLXTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo nowStart:(BOOL) start;

/**
 *  不参与自动移除
 *  默认马上执行
 *  @param block
 *  @param duration
 *
 *  @return timer 实例
 */
+ (instancetype)excuteInMainWithBlock:(dispatch_block_t)block timeInterval:(NSTimeInterval) duration;

/**
 *  不参与自动移除 在主线程中执行
 *
 *  @param block
 *  @param duration
 *  @param start
 *
 *  @return
 */
+ (instancetype)excuteInMainWithBlock:(dispatch_block_t)block timeInterval:(NSTimeInterval) duration nowStart:(BOOL) start;
/**
 *  不参与自动移除 在子线程中执行
 *
 *  @param block
 *  @param duration
 *  @param start
 *
 *  @return
 */
+ (instancetype)excuteInGlobeWithBlock:(dispatch_block_t)block timeInterval:(NSTimeInterval) duration nowStart:(BOOL) start;
/**
 *  定时器开始
 */
-(void) start;
/**
 *  定时器暂停
 */
-(void) suspend;
/**
 *  定时器停止
 */
-(void) stop;
-(void) invalidate;

/**
 *  延迟启动
 *
 *  @param time 延迟时间
 */
-(void) delayStartWithTime:(NSTimeInterval) time;

/**
 *  获得对象的定时器
 *
 *  @param target
 *  @param index  第几个
 *
 *  @return 
 */
-(QLXTimer * ) timerWithTarget:(NSObject *)target index:(NSInteger) index;
@end
