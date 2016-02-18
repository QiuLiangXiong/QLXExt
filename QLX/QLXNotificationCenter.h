//
//  QLXNotificationCenter.h
//  自动移除 监听者    用法和NSNotificationCenter 一样
//
//  Created by QLX on 15/9/20.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(NSNotification * notification);

@interface QLXNotificationCenter : NSObject

+(instancetype) defaultCenter;

+(instancetype) getInstance;

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;

- (void) addObserverWithName:(NSString *)name object:(id) objcet  block:(ActionBlock) block;

- (void)postNotification:(NSNotification *)notification;

- (void)postNotificationName:(NSString *)aName object:(id)anObject;

- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

- (void) removeWithObserver:(NSObject *)observer;

- (void) removeWithName:(NSString *)name;

@end
