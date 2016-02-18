//
//  LLabelRRadioButtonCell.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/10/14.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "LLabelRRadioButtonCell.h"
#import "QLXExt.h"
@implementation LLabelRRadioButtonCell

-(void)createUI{
    [super createUI];
    [self.rightRG.radioButtons removeAllObjects];
    [self.rightRG addRadioButtonWithTexts:@[@""]];
    [self.rightRG mas_updateConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.view).offset(0);
    }];
}

@end
