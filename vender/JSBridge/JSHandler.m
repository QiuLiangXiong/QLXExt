//
//  JSHandler.m
//  JSBridge
//
//  Created by Peter on 15/7/2.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "JSHandler.h"

@implementation JSHandler

+ (instancetype)jsHandlerWithName:(NSString *)name target:(id)target selector:(SEL)selector
{
    if(name.length == 0 || target == nil || selector == nil)
    {
        return nil;
    }
    
    if(![target respondsToSelector:selector])
    {
        return nil;
    }
    
    JSHandler *handler = [[JSHandler alloc] init];
    handler.name = name;
    handler.target = target;
    handler.selector = selector;
    
    return handler;

}

@end
