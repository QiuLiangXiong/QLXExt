//
//  UIButton+QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonActionClorce)(UIButton * sender);

@interface UIButton(QLXExt)

@property (nonatomic, strong) NSMutableArray * actionBlocks;

+(instancetype) createWithFrame:(CGRect) frame;

+(instancetype) create;

+(instancetype) createWithText:(NSString *)text;

+(instancetype) createWithText:(NSString *)text font:(UIFont *) font;

+(instancetype) createWithText:(NSString *)text fontSize:(CGFloat) fontSize;

+(instancetype) createWithText:(NSString *)text font:(UIFont *) font normal:(NSString *) normal highlighted:(NSString *) press;
+(instancetype) createWithText:(NSString *)text fontSize:(CGFloat) fontSize normal:(NSString *) normal highlighted:(NSString *) press;

+(instancetype) createWithText:(NSString *)text hexColor:(NSString *)color fontSize:(CGFloat) fontSize;

+(instancetype) createWithText:(NSString *)text hexColor:(NSString *)color fontSize:(CGFloat) fontSize normal:(NSString *) normal highlighted:(NSString *) press;

-(void)setTitleFont:(UIFont *)titleFont;

-(void) addClickActionBlock:(ButtonActionClorce) block;

@end
