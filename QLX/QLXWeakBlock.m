//
//  QLXWeakBlock.m
//
//
//  Created by QLX on 15/9/20.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import "QLXWeakBlock.h"
#import "QLXExt.h"
@interface QLXWeakBlock()
@end

@implementation QLXWeakBlock

@synthesize block = _block;

-(id)block{
    if (!self.target) {
        _block = nil;
        if ([self.delegate respondsToSelector:@selector(targetDelloc:)]) {
            [self.delegate targetDelloc:self];
        }
    }
    return _block;
}

-(void)setBlock:(id)block{
    _block = nil;
    _block = block;
}

-(void)setTarget:(id)target{
    _target = target;
    if ([target isKindOfClass:[NSObject class]]) {
        self.targetKey = [(NSObject *)target address];
    }
}

-(void)dealloc{
    self.block = nil;
    self.targetKey = nil;
}

@end
