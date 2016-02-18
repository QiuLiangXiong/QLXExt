//
//  QLXObject.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/29.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

/**
 * NSObject 死亡回调
 *  死亡回调
 */

#import <Foundation/Foundation.h>

typedef void(^ IDBlock)(id obj);

@interface QLXObject : NSObject

@property(nonatomic, strong) NSMutableArray * blocks;

@property(nonatomic, strong)  NSString * obj;

/**
 *  添加闭包
 *
 *  @param target
 *  @param block
 */
-(void) addBlockWithTarget:(id)target block:(IDBlock) block;
@end
