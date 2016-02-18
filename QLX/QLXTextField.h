//
//  QLXTextField.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/13.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QLXTextFieldDelegate;

@interface QLXTextField : UIView<UITextFieldDelegate>
@property (nonatomic, strong) UITextField              *  textField;
@property (nonatomic, weak  ) UIView                   * targetView;// 键盘抬起 移动的视图
@property (nonatomic, weak  ) UIView                   * tapView;// 点击收起 视图
@property (nonatomic, assign) NSInteger                limitTextLength;
@property (nonatomic, assign) NSInteger                remainLimitLengh;// 剩余字数
@property (nonatomic, assign) BOOL                     shakeEnale;//  字数超出限制振动提醒
@property (nonatomic, assign) BOOL                     unNumEnable;// 是否可以包含非数字
@property (nonatomic, assign) BOOL                     emojiEnable;// 是否可以包含表情
@property (nonatomic, assign) BOOL showLimitNumRemainEnable ;//剩余字数显示
@property (nonatomic, strong) UILabel                  * limitLengthInfoLbl;
@property (nonatomic, weak  ) id<  QLXTextFieldDelegate    > delegate;
@property (nonatomic, assign) CGFloat                  offset;

+(QLXTextField *) create;

+(QLXTextField *) createWithTextColor:(UIColor *) color font:(UIFont *)font;

+(QLXTextField *) createWithTextHexColorStr:(NSString *) str font:(UIFont *)font;

+(QLXTextField *) createWithTextHexColorStr:(NSString *) str fontSize:(CGFloat)size;

-(void)setTargetView:(UIView *)targetView;

-(void) tapToEndEditting;


+ (QLXTextField *)createWithTargetView:(UIView *)view;

-(void) setEdgeInsets:(UIEdgeInsets) edge;


-(NSString *)text;
@end

@protocol QLXTextFieldDelegate <UITextFieldDelegate>

@end