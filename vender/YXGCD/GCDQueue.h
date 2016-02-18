//
//  GCDQueue.h
//
//  http://home.cnblogs.com/u/YouXianMing/
//  http://www.cnblogs.com/YouXianMing/p/3659204.html  
//  Created by Y.X. on 14-4-11.
//  Copyright (c) 2014年 Y.X. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_feature(objc_arc)
#define STRONG strong
#else
#define STRONG retain
#endif

@class GCDGroup;

// 系统子线程池(并发执行)
#define CONCURRENT_H  [GCDQueue highPriorityGlobalQueue]
#define CONCURRENT_D  [GCDQueue globalQueue]
#define CONCURRENT_L  [GCDQueue lowPriorityGlobalQueue]
#define CONCURRENT_B  [GCDQueue backgroundPriorityGlobalQueue]

// 系统主线程池(序列执行)
#define SERIAL        [GCDQueue mainQueue]
#define SYS_UI        [GCDQueue mainQueue]

@interface GCDQueue : NSObject

@property (STRONG, readonly, nonatomic) dispatch_queue_t dispatchQueue;

+ (GCDQueue *)mainQueue;
+ (GCDQueue *)globalQueue;
+ (GCDQueue *)highPriorityGlobalQueue;
+ (GCDQueue *)lowPriorityGlobalQueue;
+ (GCDQueue *)backgroundPriorityGlobalQueue;

#pragma 便利的构造方法
+ (void)executeInMainQueue:(dispatch_block_t)block;
+ (void)executeOnce:(dispatch_block_t)block;
+ (void)executeInGlobalQueue:(dispatch_block_t)block;
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

#pragma 初始化以及释放
- (instancetype)init;
- (instancetype)initSerial;
- (instancetype)initConcurrent;
- (void)dispatchRelease;

#pragma 用法
- (void)execute:(dispatch_block_t)block;
- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta;
- (void)waitExecute:(dispatch_block_t)block;
- (void)barrierExecute:(dispatch_block_t)block;
- (void)waitBarrierExecute:(dispatch_block_t)block;
- (void)suspend;
- (void)resume;

#pragma 与GCDGroup相关
- (void)execute:(dispatch_block_t)block inGroup:(GCDGroup *)group;
- (void)notify:(dispatch_block_t)block inGroup:(GCDGroup *)group;

@end
