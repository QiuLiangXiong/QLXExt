//
//  QLXSegmentItem.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/28.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXSegmentItem.h"
#import "QLXExt.h"
#import "QLXSegmentItemData.h"

@interface QLXSegmentItem()


@property (nonatomic, assign) CGFloat  titleWidth;

@end

@implementation QLXSegmentItem

-(void)createUI{
    [super createUI];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.view);
    }];
}

-(void)reuseWithData:(ReuseDataBase *)data indexPath:(NSIndexPath *)indexPath{
    [super reuseWithData:data indexPath:indexPath];
    QLXSegmentItemData * rData = (QLXSegmentItemData *)data;
    [self.titleLbl setText:rData.title];
    self.titleLbl.font = rData.font;
    CGFloat titleW = [self.titleLbl sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    if (rData.title) {
        self.titleWidth = titleW + rData.titleSpace;
    }
    self.selected = self.selected;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [QLXLabel create];
        [self.view addSubview:_titleLbl];
    }
    return _titleLbl;
}

-(CGFloat)cellHeight{
    return self.collectionView.height;
}

-(CGFloat)cellWidth{
    if (self.data.width) {
        return self.data.width;
    }
    if (self.titleWidth) {
        return self.titleWidth;
    }
    return [super cellWidth];
}

-(void)selectedCell{
     QLXSegmentItemData * rData = (QLXSegmentItemData *)self.data;
    [self.titleLbl setTextColor:rData.selectorColor];
}

-(void)deSelectedCell{
    QLXSegmentItemData * rData = (QLXSegmentItemData *)self.data;
     [self.titleLbl setTextColor:rData.normalColor];
}






@end
