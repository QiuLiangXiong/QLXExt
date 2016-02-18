//
//  QLXCollectionViewCell.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/22.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXCollectionViewCell.h"
#import "QLXExt.h"
#import "QLXCollectionView.h"

@implementation QLXCollectionViewCell



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


// 可以重写 可以不用重写
-(void) createUI{
    // 分割线 默认不显示
    
}

-(void)onEnter{
    [super onEnter];
    if ([self.delegate respondsToSelector:@selector(initToConfigtWithCollectionViewCell:)]) {
        [self.delegate initToConfigtWithCollectionViewCell:self];
    }
}

// 需要重写
-(void) reuseWithData:(ReuseDataBase *) data indexPath:(NSIndexPath *) indexPath{
    self.data = data;
    self.indexPath = indexPath;
}

-(CGSize) cellSize{
    //assert(self.collectionView);
    //assert(self.collectionView);
    CGFloat width = [self cellWidth];
    CGFloat height = [self cellHeight];
    if (width) {
        self.width = width;
    }
    if (height){
        self.height = height;
    }
    if (width && height) {
        return CGSizeMake(width, height);
    }
    CGSize size = [self contentViewSize];
    if (width) {
        size.width = width;
    }
    if (height) {
        size.height = height;
    }
    self.data.height = size.width;
    self.data.width = size.height;
    return size;
    
}

-(CGFloat)cellWidth{
    return 0;
}

-(CGFloat) cellHeight{
    return 0;
}

-(CGSize) contentViewSize{
    [self refreshLayout];
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}




-(void) refresh{
}

-(UIView *)view{
    if (!_view) {
        _view = [QLXView createWithBgColor:[UIColor clearColor]];
        [self.contentView addSubview:_view];
        [_view constraintWithEdgeZero];
    }
    return _view;
}

-(void)setSelected:(BOOL)selected{
    if (selected) {
        [self selectedCell];
    }else if(self.collectionView.highlighted == false){
        [self deSelectedCell];
    }
    [super setSelected:selected];
}

-(void)selectedCell{
    
}

-(void)deSelectedCell{
    
}





@end
