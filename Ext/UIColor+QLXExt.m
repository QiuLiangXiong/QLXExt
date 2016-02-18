//
//  UIColor+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "UIColor+QLXExt.h"
#import "QLXExt.h"
@implementation UIColor(QLXExt)

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (instancetype) colorWithHexString: (NSString *)color alpha:(CGFloat) alpha{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [self colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+ (instancetype) colorWithHexString: (NSString *)color{
    return [self colorWithHexString:color alpha:1];
}

+ (instancetype) colorWithR:(CGFloat) red g:(CGFloat) green b:(CGFloat)blue{
    return [[UIColor alloc] initWithRed:red / 255.0 green:green / 255.0  blue: blue / 255.0 alpha:1];
}

@end
