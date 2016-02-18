//
//  LLabelRTwoRatioButtonCell.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/12.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "LLabelRTwoRatioButtonCell.h"
#import "QLXExt.h"
@implementation LLabelRTwoRatioButtonCell
-(void)createUI{
    [super createUI];
    [self setSeparatorLineShowWithInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    // 左边标签
    self.leftLbl = [QLXLabel createWithText:@"Label" hexColorString:@"#333333" fontSize:17];
    self.leftLbl.staticEnable = true;
    [self.view addSubview:self.leftLbl];
    [self.leftLbl mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view).offset(15);
        make.centerY.equalTo(self.view);
    }];
    // 右边 单选组
    
    self.rightRG = [QLXRadioGroup createWithStyle:(LayoutStyleHorizontal)];
    self.rightRG.normalImage = [UIImage imageNamed:@"list_icon_unchecked"];
    self.rightRG.selectedImage = [UIImage imageNamed:@"list_icon_selected"];
    [self.rightRG addRadioButtonWithTexts:@[@"女",@"男"]];
    
    self.rightRG.selectedIndex = 0;
    [self.view addSubview:self.rightRG];
    [self.rightRG mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.view).offset(-34);
        make.centerY.equalTo(self.view);
    }];
}

-(void) setContentWithLeftStr:(NSString*) left selectedIndex:(NSInteger) index {
    self.leftLbl.text = left;
    self.rightRG.selectedIndex = index;
}
- (CGFloat)cellHeight{
    return 50;
}



@end
