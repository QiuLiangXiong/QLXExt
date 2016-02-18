//
//  UIApplication+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/10/14.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "UIApplication+QLXExt.h"

@implementation UIApplication(QLXExt)

-(BOOL) isDebug{
    BOOL result = false;
#ifdef DEBUG
    result = true;
#endif
    return result;
}

-(BOOL) isRelease{
    return ![self isDebug];
}

@end
