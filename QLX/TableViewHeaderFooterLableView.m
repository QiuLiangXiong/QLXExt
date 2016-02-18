//
//  TableViewHeaderFooterLableView.m
//  QLXExtDemo
//
//  Created by QLX on 15/11/5.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "TableViewHeaderFooterLableView.h"
#import "QLXExt.h"

@implementation TableViewHeaderFooterLableView

-(void)createUI{
    [super createUI];
    self.backgroundView = [QLXView createWithBgColor:[UIColor clearColor]];
}
-(CGFloat)viewHeight{
    return self.headerFooterHeight;
}

-(QLXLabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [QLXLabel create];
        [self.view addSubview:_titleLbl];
        [_titleLbl constraintWithEdgeZero];
    }
    return _titleLbl;
}


-(void) setTitle:(NSString *)title hexColor:(NSString *)cStr fontSize:(CGFloat) size height:(CGFloat) height{
    self.titleLbl.text = title;
    self.titleLbl.textColor = [UIColor colorWithHexString:cStr];
    self.titleLbl.font = [UIFont systemFontOfSize:size ];
    self.headerFooterHeight = height;
}


@end
