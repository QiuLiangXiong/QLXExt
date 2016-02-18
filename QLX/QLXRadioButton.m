//
//  QLXRadioButton.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/12.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXRadioButton.h"
#import "QLXExt.h"
@implementation QLXRadioButton

+(QLXRadioButton *) create{
    return [[QLXRadioButton alloc] init];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

-(void) initialization{
    [self addTarget:self action:@selector(onClickRadioButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    //单选按钮
    self.radioBtn = [UIButton new];
    self.radioBtn.userInteractionEnabled = false;
    [self addSubview:self.radioBtn];
    [self.radioBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.top.greaterThanOrEqualTo(self).offset(0);
        make.bottom.greaterThanOrEqualTo(self).offset(0);
    }];
    
    // 文本
    self.textLbl = [UILabel new];
    [self setTextFont:[UIFont systemFontOfSize:15]];
    [self setTextColor:[UIColor colorWithHexString:@"#999999"]];
    [self addSubview:self.textLbl];
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.radioBtn.mas_right).offset(10);
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.top.greaterThanOrEqualTo(self);
        make.bottom.greaterThanOrEqualTo(self);
    }];
}

-(void) setTextColor:(UIColor * ) color{
    self.textLbl.textColor = color;
}

-(void) setTextFont:(UIFont *) font{
    self.textLbl.font = font;
}

-(void) setText:(NSString *)text{
    self.textLbl.text = text;
}

-(void) setRadioImageWithNomal:(NSString *) normal selected:(NSString *) selected{
    UIImage * normalImage = [UIImage imageNamed:normal];
    UIImage * selectedImage = [UIImage imageNamed:selected];
    [self setRadioImageWithNomalImage:normalImage selectedImage:selectedImage];
}

-(void) setRadioImageWithNomalImage:(UIImage *) normal selectedImage:(UIImage *) selected{
    NSAssert(normal != nil && selected != nil, @"不能为空");
    [self.radioBtn setBackgroundImage:normal forState:(UIControlStateNormal)];
    [self.radioBtn setImage:normal forState:(UIControlStateHighlighted)];
    [self.radioBtn setImage:selected forState:(UIControlStateSelected)];
    
    CGSize size = normal.size;
    [self setRadioBtnSize:size];
}

-(void) onClickRadioButton{
    if (self.radioBtn.selected == false) {
        [self setSelected];
    }else{
        [self setUnselected];
    }
}

-(void) setSelected{
    self.radioBtn.selected = true;
    self.selected = true;
}

-(void) setUnselected{
    self.radioBtn.selected = false;
    self.selected = false;
}

-(void) setRadioBtnSize:(CGSize) size{
    [self.radioBtn mas_updateConstraints:^(MASConstraintMaker *make){
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
}



@end
