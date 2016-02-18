//
//  QLXTimer.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/21.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXTimer.h"
#import "QLXExt.h"

@interface QLXTimer()

@property (nonatomic, strong) NSMutableDictionary * cacheDic;

@end

@implementation QLXTimer

+(instancetype) getInstance{
    static id instance;
    GCDExecOnce(^{
        if (instance == nil) {
            instance = [self new];
        }
    });
    return instance;
}

+ (QLXTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo nowStart:(BOOL) start{
    return [[self getInstance] timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo nowStart:start];
}

-(NSMutableDictionary *)cacheDic{
    if (!_cacheDic) {
        _cacheDic = [NSMutableDictionary new];
    }
    return _cacheDic;
}

- (QLXTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo nowStart:(BOOL) start{
    __weak typeof(&*aTarget) weakTarget = aTarget;
    __weak typeof(&*userInfo) weakUserInfo = userInfo;
    QLXTimer * timer = [QLXTimer excuteInMainWithBlock:^{
        if (weakTarget) {
            msgSend(msgTarget(weakTarget) , aSelector , (UIView *)weakUserInfo);
        }
    } timeInterval:ti nowStart:start];
    [self addTimer:timer target:aTarget];
    kBlockWeakSelf;
    [(NSObject *)aTarget performBlockOnDeallocWithTarget:self block:^(id obj) {
        [weakSelf autoRemoveWithObj:obj];
    }];
    return timer;
}

-(void) addTimer:(QLXTimer *)timer target:(NSObject *) target{
    NSString * key = [target address];
    NSMutableArray * array = [self.cacheDic valueForKey:key];
    if (array == nil) {
        array = [NSMutableArray new];
        [self.cacheDic setValue:array forKey:key];
    }
    [array addObject:timer];
}

-(void) autoRemoveWithObj:(NSObject *)obj{
    
    NSString * key;
    if ([obj isKindOfClass:[NSString class]]) {
        key = (NSString *)obj;
    }else {
        key = [NSString addressWithObject:obj];
    }
    
    [self.cacheDic removeObjectForKey:key];
}

-(void) removeWithTarget:(id)target{
    [self autoRemoveWithObj:target];
}

+ (instancetype)excuteInMainWithBlock:(dispatch_block_t)block timeInterval:(NSTimeInterval) duration{
    return [self excuteInMainWithBlock:block timeInterval:duration nowStart:true];
}

+ (instancetype)excuteInMainWithBlock:(dispatch_block_t)block timeInterval:(NSTimeInterval) duration nowStart:(BOOL) start{
    return [self excuteWithBlock:block timeInterval:duration nowStart:start queue:[GCDQueue mainQueue]];
}

+ (instancetype)excuteInGlobeWithBlock:(dispatch_block_t)block timeInterval:(NSTimeInterval) duration nowStart:(BOOL) start{
    return [self excuteWithBlock:block timeInterval:duration nowStart:start queue:[GCDQueue globalQueue]];
}

+ (instancetype)excuteWithBlock:(dispatch_block_t)block timeInterval:(NSTimeInterval) duration nowStart:(BOOL) start queue:(GCDQueue *)queue {
    QLXTimer * timer = [[QLXTimer alloc] initInQueue:queue];
    [timer event:block timeInterval:duration * NSEC_PER_SEC ] ;
    if (start) {
        [timer start];
    }else {
        __weak typeof(&*timer) weakTimer = timer;
        [GCDQueue executeInMainQueue:^{
            [weakTimer start];
        } afterDelaySecs:duration];
    }
    return timer;
}

-(QLXTimer * ) timerWithTarget:(NSObject *)target index:(NSInteger) index{
    NSMutableArray *  array = [self.cacheDic valueForKey:[target address]];
    if (array && array.count > index) {
        return [array objectAtIndex:index];
    }
    return nil;
}

-(void) start{
    [super start];
}

-(void) suspend{
    dispatch_suspend(self.dispatchSource);
}

-(void) stop{
    [self destroy];
}

-(void)invalidate{
    [self stop];
}

-(void) delayStartWithTime:(NSTimeInterval) time{
    [self suspend];
    kBlockWeakSelf;
    [GCDQueue executeInMainQueue:^{
        [weakSelf start];
    } afterDelaySecs:time];
}

-(void)dealloc{
    [self stop];
}

@end
