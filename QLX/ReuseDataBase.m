//
//  ReuseDataBase.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/10.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "ReuseDataBase.h"
#import "QLXExt.h"
@implementation ReuseDataBase
-(instancetype)init{
    self = [super init];
    if (self){
        self.height = 0;
    }
    return self;
}
-(void) heightChanged{
    self.height = 0;
}

-(NSString *) reuseIdentifier{
    return nil;
}
@end
