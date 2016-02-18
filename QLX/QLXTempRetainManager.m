//
//  QLXTempRetainManager.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/21.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXTempRetainManager.h"
#import "QLXExt.h"
@interface QLXTempRetainManager()
@property (nonatomic, strong) NSMutableArray * objects;
@end
@implementation QLXTempRetainManager

+(instancetype) getInstance{
    static id instance;
    
    
    
    GCDExecOnce(^{
        if (instance == nil) {
            instance = [self new];
        }
    });
    return instance;
}

-(NSMutableArray *)objects{
    if (!_objects) {
        _objects = [NSMutableArray new];
    }
    return _objects;
}

-(void) retainObject:(id) objcet{
    if ([self.objects containsObject:objcet] == false) {
        [self.objects addObject:objcet];
    }
}

-(void) releaseObject:(id) object{
    [self.objects removeObject:object];
}

-(BOOL) containClass:(Class) aClass{
    for (id object in self.objects) {
        if ([object isKindOfClass:aClass]) {
            return true;
        }
    }
    return false;
}

-(NSObject *) objcetWithClass:(Class) aClass{
    for (id object in self.objects) {
        if ([object isKindOfClass:aClass]) {
            return object;
        }
    }
    return nil;
}

-(NSObject *) allocOrGetObjectWithClass:(Class) aClass{
    NSObject * object = [self objcetWithClass:aClass];
    if (object == nil) {
        object = [[aClass alloc] init] ;
        [self retainObject:object];
    }
    return object;
}



@end
