//
//  QLXLabel.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/17.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXLabel.h"
#import "QLXExt.h"

@interface QLXLabel()

@property (nonatomic, strong )NSMutableAttributedString * attributedString;

@end

@implementation QLXLabel

-(void)layoutSubviews{
    self.preferredMaxLayoutWidth = self.frame.size.width; // 重点  可以实现高度计算
    [super layoutSubviews];
}
//


-(void)setText:(NSString *)text{
    
    if (self.text == nil ||[text isEqualToString:self.text] == false) {
        [super setText:text];
        [self adjustLineSpacing];
        self.preferredMaxLayoutWidth = 0;// 重点  加上这个可以调整约束布局
        [self setNeedsLayout];
    }else {
        self.preferredMaxLayoutWidth = 0;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

/**
 *  调整行间距 或 段间距
 */
-(void) adjustLineSpacing{
    if (self.lineSpace != 0 || self.paragraphSpace != 0) {
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        if (self.lineSpace) {
            [paragraphStyle setLineSpacing:self.lineSpace];
        }
        if (self.paragraphSpace) {
            [paragraphStyle setParagraphSpacing:self.paragraphSpace];
        }
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
        [self setAttributedText:attributedString];
        

    }
}

-(void) setTextColor:(UIColor *)textColor range:(NSRange)range{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:range];
    [self setAttributedText:attributedString];
}



-(void)onEnter{
    [super onEnter];
    [self adjustLineSpacing];
    if (self.staticEnable) {
        CGSize size  = [self sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        [self mas_updateConstraints:^(MASConstraintMaker *make){
            make.width.mas_equalTo(@(size.width));
            make.height.mas_equalTo(@(size.height));
            
        }];
    }
    
    
}

@end
