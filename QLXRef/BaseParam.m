//
//  BaseParam.m
//
//  Created by apple on 14-7-11.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "BaseParam.h"
#import "NSObject+MJKeyValue.h"

@interface BaseParam()
@end

@implementation BaseParam {
    NSArray * _ingoreKeys;
}

- (id)init
{
    if (self = [super init]) {
        //所有请求都有的参数,所以封装到最基本的参数里
//        self.appId = [HTTPBase shareHttpBase].appId;
//        self.deviceType = [HTTPBase shareHttpBase].deviceType;
//        self.deviceId = [HTTPBase shareHttpBase].deviceId;
//        self.appVersion = [HTTPBase shareHttpBase].appVersion;
//        self.timestamp = [HTTPBase shareHttpBase].timeStamp;
//        self.token = [HTTPBase shareHttpBase].token;
    }
    return self;
}

+ (instancetype)param
{
//设计成self是可以用于初始化子类,子类可以有无限多个
//self	Class	UserInfoParam
//self	Class	HomeStatusesParam
    return [[self alloc] init];
}

- (void)setIngoreKeys:(NSArray *)ingoreKeys
{
    _ingoreKeys = ingoreKeys;
}

- (NSMutableDictionary *)keyValues
{
    NSMutableDictionary *keyValues = [self keyValuesWithIgnoredKeys:_ingoreKeys];
    
    return [self encodeParams:keyValues];
}


- (NSMutableDictionary *)encodeParams:(NSMutableDictionary *)params
{
    for (NSString *key in [params allKeys])
    {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSString class]] && [value length] > 0)
        {
            
            NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                                          (CFStringRef)value, nil,
                                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
            
            [params setObject:encodedValue forKey:key];
        }
    }
    
    return params;
}

@end
