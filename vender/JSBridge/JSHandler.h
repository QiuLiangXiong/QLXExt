//
//  JSHandler.h
//  JSBridge
//
//  Created by Peter on 15/7/2.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSHandler : NSObject

@property(nonatomic, copy)      NSString    * name;
@property(nonatomic, weak)    id          target;
@property(nonatomic, assign)    SEL         selector;

/**
 *  JS处理记录
 *
 *  @param name     对应的JS方法
 *  @param target   处理对象
 *  @param selector 处理方法
 */
+ (instancetype)jsHandlerWithName:(NSString *)name target:(id)target selector:(SEL)selector;

@end
