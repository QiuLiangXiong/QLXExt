//
//  LLabelRImageAndArrowCell.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/12.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "LLabelRImageAndArrowCell.h"

@implementation LLabelRImageAndArrowCell

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
    
    //箭头
    self.arrowIV = [UIImageView createWithImageName:@"list_arrow_right"];
    [self.view addSubview:self.arrowIV];
    [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.view).offset(-15);
        make.centerY.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(9, 16));
    }];
    
    //右边图片
    self.rightIV = [UIImageView createWithImageName:@"head_default"];
    [self.view addSubview:self.rightIV];
    [self.rightIV setCornerWithRadius:26];
    [self.rightIV mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.arrowIV.mas_left).offset(-10);
        make.centerY.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
//    [self.view mas_makeConstraints:^(MASConstraintMaker *make){
//        make.height.mas_greaterThanOrEqualTo(@70);
//    }];
}

-(void)setContentWithLeftStr:(NSString *)left rigthtImage:(UIImage *) image{
    self.leftLbl.text = left;
    self.rightIV.image = image;
}

-(CGFloat)cellHeight{
    return 70;
}
@end
