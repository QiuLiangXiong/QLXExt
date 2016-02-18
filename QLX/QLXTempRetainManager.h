//
//  QLXTempRetainManager.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/21.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLXTempRetainManager : NSObject

+(instancetype)getInstance;

/**
 *  持有 这个对象
 *
 *  @param objcet
 */
-(void) retainObject:(id) objcet;

/**
 *  释放这个对象
 *
 *  @param object
 */

-(void) releaseObject:(id) object;

-(BOOL) containClass:(Class) class;

-(NSObject *) objcetWithClass:(Class) class;

/**
 *  根据 类 生产 或者 获得已经存在的 对象
 *
 *  @param class
 *
 *  @return
 */
-(NSObject *) allocOrGetObjectWithClass:(Class) class;

@end
