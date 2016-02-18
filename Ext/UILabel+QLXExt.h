//
//  UILabel+QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(QLXExt)
/**
 * 类方法产生一个标签
 *
 *  @return 新生成的对象
 */
+(instancetype ) create;
+(instancetype) createWithText:(NSString *)text;
+(instancetype) createWithText:(NSString *)text color:(UIColor *) color;
+(instancetype) createWithText:(NSString *)text hexColorString:(NSString *) hexString;
+(instancetype) createWithText:(NSString *)text hexColorString:(NSString *) hexString fontSize:(CGFloat) fontSize ;
+(instancetype) createWithText:(NSString *)text color:(UIColor *) color fontSize:(CGFloat) fontSize ;
+(instancetype) createWithText:(NSString *)text hexColorString:(NSString *) hexString font:(UIFont *) font ;
+(instancetype) createWithText:(NSString *)text color:(UIColor *) color font:(UIFont*) font ;
@end
