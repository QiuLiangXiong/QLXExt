//
//  QLXApplication.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/12/1.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXApplication.h"


@interface QLXApplication()

@property (nonatomic, copy) NSString * lastVersion;


@end

@implementation QLXApplication

singleInstanceImple

@synthesize lastVersion = _lastVersion;

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initConfigs];
    }
    return self;
}

-(void) initConfigs{
    if ([self.lastVersion isEqualToString:self.curVersion] == false) {
        self.newVersion = true;
        self.lastVersion = self.curVersion;
    }
}


-(NSString *)lastVersion{
    if (!_lastVersion) {
        _lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_version"];
    }
    return _lastVersion;
}

-(void)setLastVersion:(NSString *)lastVersion{
    if ([lastVersion isEqualToString:self.lastVersion] == false) {
        [[NSUserDefaults standardUserDefaults] setObject:lastVersion forKey:@"app_version"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(NSString *)curVersion{
    NSString *key = @"CFBundleShortVersionString";
    return [NSBundle mainBundle].infoDictionary[key];
}


@end
