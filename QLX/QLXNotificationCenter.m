//
//  QLXNotificationCenter.m
//
//
//  Created by QLX on 15/9/20.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import "QLXNotificationCenter.h"
#import "QLXExt.h"



@interface QLXNotificationCenter()<QLXWeakBlockDelegate>

@property(nonatomic , strong) NSMutableDictionary * keyValueDic;

@end


@implementation QLXNotificationCenter

+(instancetype) getInstance{
    static id instance;
    GCDExecOnce(^{
        if (instance == nil) {
            instance = [self new];
        }
    });
    return instance;
}

+(instancetype) defaultCenter{
    return [QLXNotificationCenter getInstance];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.keyValueDic = [NSMutableDictionary new];
    }
    return self;
}
// 不支持去重
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject{
    QLXWeakBlock * weakBlock = [QLXWeakBlock new];
    weakBlock.target = observer;
    weakBlock.otherInfo = anObject;
    __weak typeof(&*observer) weakObserver = observer;
    ActionBlock block = ^(NSNotification * notification){
        if (weakObserver) {
            msgSend(msgTarget(weakObserver),aSelector , (UIView *)notification);
        }
    };
    weakBlock.block = block;
    [self addObserverWithName:aName block:weakBlock];
    [self autoRemoveWithObserver:observer block:weakBlock];
}

-(void) addObserverWithName:(NSString *)name object:(id) objcet  block:(ActionBlock) block{
    QLXWeakBlock * weakBlock = [QLXWeakBlock new];
    weakBlock.target = self;
    weakBlock.otherInfo = objcet;
    weakBlock.block = block;
    [self addObserverWithName:name block:weakBlock];
}

-(void) postNotifications:(NSNotification *) notification {
    NSString * key = notification.name;
    NSMutableArray * array  = [self.keyValueDic valueForKey:key];
    for (int i = 0 ; i < array.count; ++i) {
        QLXWeakBlock  * weakBlock = [array objectAtIndex:i];
        if ( weakBlock.block && (notification.object == weakBlock.otherInfo || weakBlock.otherInfo == nil)) {
            ActionBlock block = weakBlock.block;
            block(notification);
        }
    }
}




- (void)postNotification:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)postNotificationName:(NSString *)aName object:(id)anObject{
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject];
}

- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
}

- (NSMutableArray * ) getValuesWithName:(NSString *)name{
    NSMutableArray * array = [self.keyValueDic objectForKey:name];
    if (array == nil) {
        array = [NSMutableArray new];
        [self.keyValueDic setValue:array forKey:name];
    }
    return array;
}

-(void)  addObserverWithName:(NSString *)name block:(QLXWeakBlock *)block{
    if ([self isExistWithName:name block:block] == false) {
        NSMutableArray * values = [self getValuesWithName:name];
        [values addObject:block];
        [self addObserverWithName:name];
    }
}


-(void) addObserverWithName:(NSString *)name{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postNotifications:) name:name object:nil];
}

-(void) autoRemoveWithObserver:(id)observer block:(QLXWeakBlock *)block{
    if ([observer isKindOfClass:[NSObject class]]) {
        kBlockWeakSelf;
        [(NSObject *)observer performBlockOnDeallocWithTarget:self block:^(id obj) {
            [weakSelf removeWithObserver:obj];
        }];
    }
}

-(BOOL) isExistWithName:(NSString *)name block:(QLXWeakBlock *)block{
    NSMutableArray * array  = [self.keyValueDic valueForKey:name];
    for (int i = 0 ; i < array.count; ++i) {
        QLXWeakBlock  * weakBlock = [array objectAtIndex:i];
        if (block.target == weakBlock.target && block.otherInfo == weakBlock.otherInfo) {
            return true;
        }
    }
    return false;
}

-(void) removeWithObserver:(NSObject *)observer{
    NSString * key = (NSString *)observer;
    if (![observer isKindOfClass:[NSString class]]) {
        key = [observer address];
    }
    NSArray * array = [self.keyValueDic.allKeys copy];
    for (NSString * key in array) {
        NSMutableArray * values = [self.keyValueDic valueForKey:key];
        if (values) {
            for (int j = 0 ; j < values.count; ++ j) {
                QLXWeakBlock * block = [values objectAtIndex:j];
                if ([block.targetKey isEqualToString:key]) {
                    [values removeObject:block];
                    --j;
                }
            }
            if (values.count == 0) {
                [self.keyValueDic removeObjectForKey:key];
            }
        }
    }
}


-(void) removeWithName:(NSString *)name{
    [self.keyValueDic removeObjectForKey:name];
}


@end
