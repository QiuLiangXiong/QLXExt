//
//  QLXTextView.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/15.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QLXTextViewDelegate;

@interface QLXTextView : UIView

@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) UILabel * placeholderLbl;
@property (nonatomic, copy) NSString * placeholder;
@property (nonatomic, strong) UILabel * limitLengthInfoLbl;
@property (nonatomic, weak) UIView * targetView; // 键盘抬起 移动的视图
@property (nonatomic, weak) UIView * tapView; // 点击收起 视图
@property (nonatomic, assign) NSInteger limitTextLength; // 字数限制
@property (nonatomic, assign) BOOL shakeEnable; //
@property (nonatomic, assign) NSInteger remainLimitLengh; // 剩余字数
@property (nonatomic, assign) BOOL newLineEnable; // 是否可以换行
@property (nonatomic, assign) BOOL unNumEnable;   // 是否可以包含非数字
@property (nonatomic, assign) BOOL emojiEnable;   // 是否可以包含表情
@property (nonatomic, assign) BOOL returnEnable;  // return 结束输入
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) id<QLXTextViewDelegate> delegate;

+ (QLXTextView *) create;

+ (QLXTextView *) createWithTextColor:(UIColor *) color font:(UIFont *) font;

+ (QLXTextView *) createWithTextHexColorStr:(NSString *) str font:(UIFont *) font;

+ (QLXTextView *) createWithTextHexColorStr:(NSString *) str fontSize:(CGFloat) size;


- (void)setTargetView:(UIView *)targetView;

- (void) tapToEndEditting;

+ (QLXTextView *)createWithTargetView:(UIView *)view;

- (void) setEdgeInsets:(UIEdgeInsets) edge;

-(NSString *) text;

@end

@protocol QLXTextViewDelegate <UITextViewDelegate>

// 显示 剩余 字数 的 将要变化信息的代理
-(void) textView:(QLXTextView *)textView showInfoInLbl:(UILabel *)label limitRemainInfoViewWillChangeWithInputNum:(NSInteger) num ;

@end
