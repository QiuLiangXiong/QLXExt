//
//  ATWidgetManager.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/27.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "ATWidgetManager.h"
#import "ATTableWidgetView.h"
#import "QLXExt.h"


@interface ATWidgetManager()

@property (nonatomic, strong) NSMutableDictionary * registerDic;

@end
@implementation ATWidgetManager

+(instancetype) getInstance{
    static id instance;
    GCDExecOnce(^{
        if (instance == nil) {
            instance = [self new];
        }
    });
    return instance;
}

-(NSMutableDictionary *)registerDic{
    if (!_registerDic) {
        _registerDic = [NSMutableDictionary new];
    }
    return _registerDic;
}

-(void) registerTableWidgetViewWithController:(UIViewController *) controller tableWidgeView:(ATTableWidgetView *)table{
    kBlockWeakSelf;
    NSString * className = [controller className];
    [controller performBlockOnDeallocWithTarget:self block:^(id obj) {
        [weakSelf.registerDic removeObjectForKey:className];
    }];
    [self.registerDic setObject:table forKey:[controller className]];
}

-(ATTableWidgetView * ) getTableWidgetViewWithControllerClass:(Class) aClass;{
    return [self.registerDic objectForKey:NSStringFromClass(aClass)];
}



@end
