//
//  QLXRadioGroup.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/12.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXRadioGroup.h"
#import "QLXExt.h"
#import "QLXRadioButton.h"
@implementation QLXRadioGroup
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initialization ];
    }
    return self;
}

-(void) initialization{
    self.verticalPadding = 10;
    self.horizontalPadding = 20;
    self.bLoad = false;
    self.multiSelectEnable = false;
    self.radioButtons = [NSMutableArray new];
    self.selectedIndex = -1;
}

+(QLXRadioGroup *) createWithStyle:(LayoutStyle) style{
    QLXRadioGroup * radioGroup = [[QLXRadioGroup alloc] init];
    radioGroup.frame = CGRectMake(0, 0, 2, 2);
    radioGroup.style = style;
    return radioGroup;
}

-(void) addRadioButtonsWithButtons:(NSArray *) buttons{
    [self.radioButtons addObjectsFromArray:buttons];
}

-(void) addRadioButtonWithButton:(QLXRadioButton *) button{
    [self.radioButtons addObject:button];
}

-(void) addRadioButtonWithTexts:(NSArray *) texts{
    for (NSString * text in texts) {
        [self addRadioButtonWithText:text];
    }
}

-(void) addRadioButtonWithText:(NSString*) text {
    QLXRadioButton * button = [QLXRadioButton create];
    if (self.normalImage != nil && self.selectedImage != nil) {
        [button setRadioImageWithNomalImage:self.normalImage selectedImage:self.selectedImage];
    }
    [button setText:text];
    [self addRadioButtonWithButton:button];

}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.bLoad == false) {
        self.bLoad = true;
        NSUInteger count = self.radioButtons.count;
        CGFloat offsetH = 0;
        CGFloat offsetV = 0;
        CGFloat maxWidth = 0;
        CGFloat maxHeight = 0;
        for (int i = 0; i < count; i++) {
            QLXRadioButton * button = [self.radioButtons objectAtIndex:i];
            CGSize size = [button getLayoutSize];
            [button addTarget:self action:@selector(selectButtonCallback:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:button];
            if (self.selectedIndex == i) {
                [button setSelected];
            }
            button.frame = CGRectMake(offsetH, offsetV, size.width, size.height);
            // 位置确定了在迭代下一个的位置
            if (self.style == LayoutStyleHorizontal) {
                offsetH += size.width + self.horizontalPadding;
            }else {
                offsetV += size.height + self.verticalPadding;
            }
            maxWidth = fmax(maxWidth, size.width);
            maxHeight = fmax(maxHeight, size.height);
        }
        [self mas_updateConstraints:^(MASConstraintMaker *make){
            if (self.style == LayoutStyleHorizontal){
                make.size.mas_equalTo(CGSizeMake(offsetH - self.horizontalPadding, maxHeight));
            }else{
                make.size.mas_equalTo(CGSizeMake(maxWidth, offsetV - self.verticalPadding));
            }
            
        }];
    }
    
}

-(void) selectButtonCallback:(QLXRadioButton *) sender{
    if (self.multiSelectEnable == false) {
        NSInteger i = 0;
        for (QLXRadioButton * button in self.radioButtons) {
            if (button != sender) {
                [button setUnselected];
            }else{
                [button setSelected];
                _selectedIndex = i;
            }
            i++;
        }
    }
    if ([self.delegate respondsToSelector:@selector(valueChanged:)]) {
        [self.delegate valueChanged:sender];
    }
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    NSInteger i = 0;
    for (QLXRadioButton * button in self.radioButtons) {
        if (selectedIndex == i) {
            [button setSelected];
        }else {
             [button setUnselected];
        }
        i++;
    }
}





@end
