//
//  BaseParam.h
//
//  Created by apple on 14-7-11.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseParam : NSObject

@property(nonatomic, copy) NSString *appId;
@property(nonatomic, copy) NSString *deviceType;
@property(nonatomic, copy) NSString *appVersion;
@property(nonatomic, copy) NSString *deviceId;
@property(nonatomic, assign) long timestamp;
@property(nonatomic, copy) NSString* token;

+ (instancetype)param;
/**
 *  忽略某些字段
 *
 *  @param ingoreKeys 需要忽略的字段名
 */
- (void)setIngoreKeys:(NSArray *)ingoreKeys;

@end
