//
//  QLXTimeManager.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/11/9.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLXTimeManager : NSObject


+(instancetype) getInstance;

-(NSTimeInterval) curTimestamp;

-(void) adjustTimeWithTimestamp:(NSTimeInterval) timestamp;

-(long long) curLongLongTimestamp;

@end
