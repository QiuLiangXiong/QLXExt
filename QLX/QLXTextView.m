//
//  QLXTextView.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/15.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXTextView.h"
#import "QLXExt.h"
#import "UILabel+QLXExt.h"
@interface QLXTextView()<UITextViewDelegate>
@property (nonatomic, assign) CGRect targetFrame;
@property (nonatomic, assign) CGRect frameInWindow;
@property (nonatomic, assign,getter=isFirst) BOOL first;
@property (nonatomic, strong) UITextField * cacheTextField; // 当做文本的去除换行
@property (nonatomic, strong) UITapGestureRecognizer * tapGR;

@property (nonatomic, copy) NSString * lastText;   // 修改之前的文本
@end
@implementation QLXTextView

+ (QLXTextView *) create{
    return [QLXTextView new];
}

+ (QLXTextView *) createWithTextColor:(UIColor *) color font:(UIFont *) font{
    QLXTextView * textView = [QLXTextView new];
    textView.textView.font = font;
    textView.textView.textColor = color;
    return textView;
}

+ (QLXTextView *) createWithTextHexColorStr:(NSString *) str font:(UIFont *) font{
    return  [QLXTextView createWithTextColor:[UIColor colorWithHexString:str] font:font];
}

+ (QLXTextView *) createWithTextHexColorStr:(NSString *) str fontSize:(CGFloat) size{
    return  [QLXTextView createWithTextColor:[UIColor colorWithHexString:str] font:[UIFont systemFontOfSize:size]];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initConfigs];
    }
    return self;
}


// 初始化配置
-(void) initConfigs{
    self.textView.delegate = self;
    self.frame = CGRectZero;
    self.backgroundColor = [UIColor whiteColor];
    self.first = true;
    self.limitTextLength = 0;
    self.emojiEnable = true;
    self.unNumEnable = true;
    self.newLineEnable = true;
    self.returnEnable = true;
    self.shakeEnable = false;
    self.offset = 0;
    [self.textView constraintWithEdgeZero];
    
}

-(void)onEnter{
    [self textViewChange:self.textView];
}

-(UITextField *)cacheTextField{
    if (!_cacheTextField) {
        _cacheTextField = [UITextField new];
    }
    return _cacheTextField;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.clipsToBounds = true;
        [self addSubview:_textView];
    }
    return _textView;
}
-(UILabel *)placeholderLbl{
    if (!_placeholderLbl) {
        _placeholderLbl = [UILabel createWithText:@"placeHolder" hexColorString:@"#b6b6b6" font:self.textView.font];
        _placeholderLbl.numberOfLines = 0;
        _placeholderLbl.hidden = ![self.textView.text isEqualToString:@""];;
        [self.textView addSubview:_placeholderLbl];
        [_placeholderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView).offset(8);
            make.left.equalTo(self.textView).offset(4);
            make.right.equalTo(self.textView).offset(-8);
            //make.bottom.equalTo(self.textView);
        }];
    }
    return _placeholderLbl;
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLbl.hidden = ![self.textView.text isEqualToString:@""];
    self.placeholderLbl.font = self.textView.font;
    self.placeholderLbl.text = _placeholder;
}

-(UILabel *)limitLengthInfoLbl{
    if (!_limitLengthInfoLbl ) {
        _limitLengthInfoLbl = [UILabel createWithText:@"Label" hexColorString:@"#b6b6b6" fontSize:14];
        [self addSubview:_limitLengthInfoLbl];
        [_limitLengthInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.bottom.equalTo(self).offset(-10);
        }];
        _limitLengthInfoLbl.hidden = true;
    }
    return _limitLengthInfoLbl;
}
-(void) setEdgeInsets:(UIEdgeInsets) edge{
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(edge.top);
        make.left.equalTo(self).offset(edge.left);
        make.right.equalTo(self).offset(-edge.right);
        make.bottom.equalTo(self).offset(-edge.bottom);
    }];
}

-(UITapGestureRecognizer *)tapGR{
    if (!_tapGR) {
        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEndEditting)];
        _tapGR.delaysTouchesBegan = false;
    }
    return _tapGR;
}

-(void) tapToEndEditting{
    [self.textView resignFirstResponder];
}

+ (QLXTextView *)createWithTargetView:(UIView *)view{
    QLXTextView * textView = [QLXTextView create];
    textView.targetView = view;
    return textView;
}

-(void) textViewChange:(UITextView *) textView{
    UITextRange * selectedRange = textView.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if (!self.newLineEnable) {
            self.cacheTextField.text = textView.text;
            textView.text = self.cacheTextField.text;
        }
        
        if (![self shouldChangeWithReplaceText:textView.text]) {
            kBlockWeakSelf;
            [self performInNextLoopWithBlock:^{
                [weakSelf limitAsText:self.lastText];
            }];
            return ;
        }else {
            self.lastText = textView.text;
        }
        
        
        if (self.limitTextLength != 0) {
            if (textView.text.length > self.limitTextLength) {
                NSString *limitText = [textView.text substringToIndex:self.limitTextLength];
                if (self.shakeEnable) {
                    [self.textView animateWithShake];
                }
                [self performSelector:@selector(limitAsText:) withObject:limitText afterDelay:0];
            }else {
                [self caculTextNum:textView.text];
            }
        }
    }
    self.placeholderLbl.hidden = ![self.textView.text isEqualToString:@""];
}

-(NSString *) text{
    if (self.limitTextLength > 0 && self.textView.text.length > self.limitTextLength) {
        return [self.textView.text substringToIndex:self.limitTextLength];
    }
    return self.textView.text;
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

- (void)limitAsText:(NSString *)text
{
    self.textView.text = text;
    self.lastText = text;
    [self caculTextNum:text];
}

-(void) caculTextNum:(NSString *) text{
    self.remainLimitLengh = self.limitTextLength - text.length;
}

-(void)setLimitTextLength:(NSInteger)limitTextLength{
    _limitTextLength = limitTextLength;
    self.remainLimitLengh = _limitTextLength;
    self.limitLengthInfoLbl.hidden = _limitTextLength == 0;
}

-(void) setRemainLimitLengh:(NSInteger)remainLimitLengh{
    _remainLimitLengh = remainLimitLengh;
    [self setLimitTextLengthLbl];
}

-(void) setLimitTextLengthLbl{
    NSInteger inputNum =self.limitTextLength - self.remainLimitLengh;
    self.limitLengthInfoLbl.text = [NSString stringWithFormat:@"(%ld/%ld)",(long)inputNum,(long)self.limitTextLength ];
    //self.limitLengthInfoLbl.hidden = self.remainLimitLengh == self.limitTextLength;
    if ([self.delegate respondsToSelector:@selector(textView:showInfoInLbl:limitRemainInfoViewWillChangeWithInputNum:)]) {
        [self.delegate textView:self showInfoInLbl:self.limitLengthInfoLbl limitRemainInfoViewWillChangeWithInputNum:inputNum];
    }
}

-(void) keyboardWillShow:(CGFloat) height{
    if (self.targetView ) {
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
            self.targetView.frame = targetFrame;
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

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.isFirst) {
        self.first = false;
        if (self.targetView) {
            self.targetFrame = self.targetView.frame;
            self.targetView.translatesAutoresizingMaskIntoConstraints = true;
        }
        
        UIView * rootView = [UIApplication sharedApplication].keyWindow;
        CGRect frame = [self convertRect:self.bounds toView:rootView];
        self.frameInWindow = frame;
        self.placeholderLbl.font = self.textView.font;
        self.placeholderLbl.hidden = ![self.textView.text isEqualToString:@""];
        [self limitAsText:self.textView.text];
        self.placeholderLbl.preferredMaxLayoutWidth = self.textView.bounds.size.width-12;
    }
}


#pragma mark - 过滤
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
// 是否包含换行符
-(BOOL) containNewLineWithString:(NSString *) text{
    self.cacheTextField.text = text;
    return ![self.cacheTextField.text isEqualToString:text];
}

-(BOOL) shouldChangeWithReplaceText:(NSString *) text{
    BOOL result = true;
    if (result && !self.emojiEnable) {
        result = ![self containEmojiWithString:text];
    }
    if (result && !self.newLineEnable) {
        result = ![self containNewLineWithString:text];
    }
    if (result && !self.unNumEnable) {
        result = ![self containUnNumWithString:text];
    }
    if ( !self.returnEnable) {
        if ([text isEqualToString:@"\n"]) {
            [self.textView resignFirstResponder];
        }
    }
    return result;
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self addKeyboardObserver];
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.delegate textViewShouldBeginEditing:textView];
    }
    return true;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if ([self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.delegate textViewShouldEndEditing:textView];
    }
    return true;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.delegate textViewDidBeginEditing:textView];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self removeKeyboardObserver];
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.delegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return true;
}
- (void)textViewDidChange:(UITextView *)textView{
    [self textViewChange:textView];//
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.delegate textViewDidChangeSelection:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([self.delegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
        return [self.delegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    }
    return true;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    if ([self.delegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]) {
        return [self.delegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return true;
}

@end
