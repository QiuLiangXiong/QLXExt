//
//  QLXTextField.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/13.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXTextField.h"
#import "QLXExt.h"
#import "UILabel+QLXExt.h"
@interface QLXTextField()
@property (nonatomic, assign) CGRect targetFrame;
@property (nonatomic, assign) CGRect frameInWindow;
@property (nonatomic, assign,getter=isFirst) BOOL first;
@property (nonatomic, strong) UITapGestureRecognizer * tapGR;
@property (nonatomic, copy) NSString * lastText;   // 修改之前的文本
@end
@implementation QLXTextField

+(QLXTextField *) create{
    return [QLXTextField new];
}

+(QLXTextField *) createWithTextColor:(UIColor *) color font:(UIFont *)font{
    QLXTextField * textField = [QLXTextField create];
    textField.textField.font = font;
    textField.textField.textColor = color;
    return textField;
}


+(QLXTextField *) createWithTextHexColorStr:(NSString *) str font:(UIFont *)font{
    return [QLXTextField createWithTextColor:[UIColor colorWithHexString:str ] font:font];
}

+(QLXTextField *) createWithTextHexColorStr:(NSString *) str fontSize:(CGFloat)size{
    return [QLXTextField createWithTextColor:[UIColor colorWithHexString:str ] font:[UIFont systemFontOfSize:size]];
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [UITextField new];
        [self addSubview:_textField];
        [_textField constraintWithEdgeZero];
    }
    return _textField;
}

-(UITapGestureRecognizer *)tapGR{
    if (!_tapGR) {
        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEndEditting)];
        _tapGR.delaysTouchesBegan = false;
    }
    return _tapGR;
}

-(void) tapToEndEditting{
    [self.textField resignFirstResponder];
}

-(void) setRemainLimitLengh:(NSInteger)remainLimitLengh{
    _remainLimitLengh = remainLimitLengh;
    [self setLimitTextLengthLbl];
}
-(void) setLimitTextLengthLbl{
    NSInteger inputNum =self.limitTextLength - self.remainLimitLengh;
    self.limitLengthInfoLbl.text = [NSString stringWithFormat:@"(%ld/%ld)",(long)inputNum,(long)self.limitTextLength ];
}
-(void)setShowLimitNumRemainEnable:(BOOL)showLimitNumRemainEnable{
    _showLimitNumRemainEnable = showLimitNumRemainEnable;
    self.limitLengthInfoLbl.hidden = !showLimitNumRemainEnable;
}

-(UILabel *)limitLengthInfoLbl{
    if (!_limitLengthInfoLbl) {
        _limitLengthInfoLbl = [UILabel createWithText:@"Label" hexColorString:@"#999999" fontSize:14];
        [self addSubview:_limitLengthInfoLbl];
        [_limitLengthInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.bottom.equalTo(self).offset(20);
        }];
    }
    return _limitLengthInfoLbl;
}
+ (QLXTextField *)createWithTargetView:(UIView *)view{
    QLXTextField * textField = [[QLXTextField alloc] init];
    textField.targetView = view;
    return textField;
}

-(void)setTargetView:(UIView *)targetView{
    _targetView = targetView;
    self.targetFrame = _targetView.frame;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}
-(void)initConfig{
    self.frame = CGRectZero;
    self.backgroundColor = [UIColor whiteColor];
    self.textField.delegate = self;
    self.first = true;
    self.limitTextLength = 0;
    self.unNumEnable = true;
    self.emojiEnable = true;
    self.shakeEnale = true;
    self.showLimitNumRemainEnable = false;
    self.offset = 0;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:(UIControlEventEditingChanged)];
}

-(void)onEnter{
    [self textFieldDidChange:self.textField];
}

-(NSString *)text{
    if (self.limitTextLength > 0 && self.textField.text.length > self.limitTextLength) {
        return [self.textField.text substringToIndex:self.limitTextLength];
    }
    return self.textField.text;
}

-(void) textFieldDidChange:(UITextField *) textField{
    UITextRange * selectedRange = textField.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if (![self shouldChangeWithReplaceText:textField.text]) {
            kBlockWeakSelf;
            [self performInNextLoopWithBlock:^{
                [weakSelf limitAsText:self.lastText];
            }];
            return ;
        }else {
            self.lastText = textField.text;
        }
        if (self.limitTextLength != 0) {
            if (textField.text.length > self.limitTextLength) {
                NSString *limitText = [textField.text substringToIndex:self.limitTextLength];
                if (self.shakeEnale) {
                    [self.textField animateWithShake];
                }
                kBlockWeakSelf;
                [self performInNextLoopWithBlock:^{
                    [weakSelf limitAsText:limitText];
                }];
            }else {
                [self caculTextNum:self.textField.text];
            }
        }
    }
}


-(void)setLimitTextLength:(NSInteger)limitTextLength{
    _limitTextLength = limitTextLength;
    self.remainLimitLengh = limitTextLength;
}

- (void)limitAsText:(NSString *)text
{
    self.textField.text = text;
    self.lastText = text;
    [self caculTextNum:text];

}

-(void) caculTextNum:(NSString *) text{
    self.remainLimitLengh = self.limitTextLength - text.length;
}

-(void) setEdgeInsets:(UIEdgeInsets) edge{
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(edge.top);
        make.left.equalTo(self).offset(edge.left);
        make.right.equalTo(self).offset(-edge.right);
        make.bottom.equalTo(self).offset(-edge.bottom);
    }];
}

-(void) keyboardWillShow:(CGFloat) height{
    if (self.targetView ) {
        self.targetView.translatesAutoresizingMaskIntoConstraints = true;
        CGRect targetFrame = self.targetFrame;
        
        UIView * rootView = [UIApplication sharedApplication].keyWindow;
        CGRect frame = self.frameInWindow;
        CGFloat bottomHeight =rootView.bounds.size.height-(frame.origin.y+frame.size.height);
        CGFloat offset = height - (bottomHeight - self.offset);
        if (offset < 0) {
            offset = 0;
        }
        targetFrame.origin.y -= offset;
        
        
        if ([QLXKeyboard getInstance].isShowKeyboard) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            self.targetView.frame = targetFrame;
            [UIView commitAnimations];
        }else {
           // [UIView beginAnimations:nil context:nil];
            //[UIView setAnimationDuration:0.3];
            self.targetView.frame = targetFrame;
           // [UIView commitAnimations];
        }
    }
}

-(void) keyboardWillHide:(CGFloat) height{
    if (self.targetView) {
        if ([QLXKeyboard getInstance].isShowKeyboard) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            self.targetView.frame = self.targetFrame;
            [UIView commitAnimations];
        }else {
            self.targetView.frame = self.targetFrame;
        }
    }
}


-(void) addKeyboardObserver{
    kBlockWeakSelf;
    [[QLXKeyboard getInstance] addKeyboardWillShowBlock:^(CGFloat addHeight, CGFloat height, CGFloat duration) {
        [weakSelf keyboardWillShow:height];
    }];
    [[QLXKeyboard getInstance] addKeyboardWillHideBlock:^(CGFloat addHeight, CGFloat height, CGFloat duration) {
        [weakSelf keyboardWillHide:height];
    }];
    if (self.targetView) {
        if (self.tapView != nil) {
            [self.tapView addGestureRecognizer:self.tapGR];
        }else {
            [self.targetView addGestureRecognizer:self.tapGR];
        }
    }else {
        if (self.tapView != nil) {
            [self.tapView addGestureRecognizer:self.tapGR];
        }
    }
    if ([[QLXKeyboard getInstance] isShowKeyboard]) {
        [self keyboardWillShow:[QLXKeyboard getInstance].keyBoardHeight];
    }
}

-(void) removeKeyboardObserver{
    [[QLXKeyboard getInstance] removeBlock];
    if (self.targetView) {
        [self keyboardWillHide:0];
        [self.targetView removeGestureRecognizer:self.tapGR];
    }
}

- (NSString *)disableEmoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}


// 是否包含 表情
-(BOOL) containEmojiWithString:(NSString *) text{
    return ![[self disableEmoji:text] isEqualToString:text];
}

// 是否有非数字
-(BOOL) containUnNumWithString:(NSString *) text{
    NSCharacterSet * cs = [NSCharacterSet decimalDigitCharacterSet];
    NSString * str = [text copy];
    return ![[str stringByTrimmingCharactersInSet:cs] isEqualToString:@""];
}

-(BOOL) shouldChangeWithReplaceText:(NSString *) text{
    BOOL result = true;
    if (result && !self.emojiEnable) {
        result = ![self containEmojiWithString:text];
    }
    if (result && !self.unNumEnable) {
        result = ![self containUnNumWithString:text];
    }
    return result;
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.delegate textFieldShouldBeginEditing:textField];
    }
    return true;
}// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self addKeyboardObserver];
    if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate textFieldDidBeginEditing:textField];
    }
}// became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.delegate textFieldShouldEndEditing:textField];
    }
    return true;
}// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self removeKeyboardObserver];
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:textField];
    }
}
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return true;
}
//
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.delegate textFieldShouldClear:textField];
    }
    return true;
}// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.delegate textFieldShouldReturn:textField];
    }
    [self.textField resignFirstResponder];
    return true;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.isFirst) {
        self.first = false;
        UIView * rootView = [UIApplication sharedApplication].keyWindow;
        if (self.targetView) {
            self.targetFrame = self.targetView.frame;
            self.targetView.translatesAutoresizingMaskIntoConstraints = true;
        }
        CGRect frame = [self convertRect:self.bounds toView:rootView];
        self.frameInWindow = frame;
    }
}


@end
