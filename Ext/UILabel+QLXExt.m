//
//  UILabel+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "UILabel+QLXExt.h"
#import "QLXExt.h"
@implementation UILabel(QLXExt)
+(instancetype) create{
    UILabel * label = [[self alloc] init];
    label.numberOfLines = 0;
    return  label;
}

+(instancetype) createWithText:(NSString *)text{
    UILabel * label = [self create];
    label.text = text;
    return label;
}

+(instancetype) createWithText:(NSString *)text color:(UIColor *) color{
    UILabel * label = [self createWithText:text];
    label.textColor = color;
    return label;
}

+(instancetype) createWithText:(NSString *)text hexColorString:(NSString *) hexString{
    UILabel * label = [self createWithText:text];
    label.textColor = [UIColor colorWithHexString:hexString];
    return label;
}

+(instancetype) createWithText:(NSString *)text hexColorString:(NSString *) hexString fontSize:(CGFloat) fontSize {
    UILabel * label = [self createWithText:text hexColorString:hexString];
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

+(instancetype) createWithText:(NSString *)text color:(UIColor *) color fontSize:(CGFloat) fontSize {
    UILabel * label = [self createWithText:text color:color];
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

+(instancetype) createWithText:(NSString *)text hexColorString:(NSString *) hexString font:(UIFont *) font {
    UILabel * label = [self createWithText:text hexColorString:hexString];
    label.font = font;
    return label;
}

+(instancetype) createWithText:(NSString *)text color:(UIColor *) color font:(UIFont*) font {
    UILabel * label = [self createWithText:text color:color];
    label.font = font;
    return label;
}


@end
