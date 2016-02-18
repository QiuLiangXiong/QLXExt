//
//  UITabBarItem+QLXExt.m
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "UITabBarItem+QLXExt.h"

@implementation UITabBarItem(QLXExt)

-(void) setTitleColor:(UIColor *) color forState:(UIControlState)state{
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:state];
}

@end
