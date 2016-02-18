//
//  QLXTimeManager.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/11/9.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXTimeManager.h"
#import "QLXExt.h"

@interface QLXTimeManager()

@property (nonatomic, assign) NSTimeInterval offsetTime;  // 偏移时间

@end


@implementation QLXTimeManager

static id instance;
+(instancetype) getInstance{
    //static id instance;
    GCDExecOnce(^{
        if (instance == nil) {
            instance = [self new];
        }
    });
    return instance;
}

+(void) destoryInstance{
    instance = nil;
}

-(NSTimeInterval) curTimestamp{
    return [[NSDate date] timeIntervalSince1970] + self.offsetTime;
}

-(long long) curLongLongTimestamp{
    return (long long)([self curTimestamp] * 1000);
}

-(void) adjustTimeWithTimestamp:(NSTimeInterval) timestamp{
    
    self.offsetTime = timestamp - [[NSDate date] timeIntervalSince1970];
    NSLog(@"%.2lf",self.offsetTime);
}



@end
