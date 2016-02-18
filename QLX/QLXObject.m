//
//  QLXObject.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/29.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXObject.h"
#import "QLXExt.h"
#import  <objc/runtime.h>


@implementation QLXObject

-(void) addBlockWithTarget:(id)target block:(IDBlock) block{
    QLXWeakBlock * weakBlock = [QLXWeakBlock new];
    weakBlock.target = target;
    weakBlock.block = block;
    [self.blocks addObject:weakBlock];
}

-(void)dealloc{
    for (QLXWeakBlock * block in self.blocks) {
        if (block.block) {
            IDBlock idBlock = block.block;
            idBlock(self.obj);
        }
    }
}

-(NSMutableArray *)blocks{
    if (!_blocks) {
        _blocks = [NSMutableArray new];
    }
    return _blocks;
}

@end
