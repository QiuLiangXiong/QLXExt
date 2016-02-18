//
//  QLXCollectionReusableView.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/22.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXCollectionReusableView.h"
#import "QLXExt.h"

@implementation QLXCollectionReusableView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI{
    
}

-(void)reuseWithData:(ReuseDataBase *)data section:(NSInteger)section isHeader:(BOOL)bHeader{
    self.data = data;
    self.section = section;
    self.bHeader = bHeader;
}

-(CGSize)viewSize{
    //assert(self.collectionView);
    CGFloat width = [self viewWidth];
    CGFloat height = [self viewHeight];
    if (width == 0 && height != self.collectionView.height) {
        width = self.collectionView.width;
    }else if (height == 0 && width != self.collectionView.width){
        height = self.collectionView.height;
    }
    if (width) {
        self.width = width;
    }
    if (height){
        self.height = height;
    }
    if (width && height) {
        return CGSizeMake(width, height);
    }
    CGSize size = [self getLayoutSize];
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



//-(CGFloat) viewHeight{
//    self.width = self.collectionView.width;
//    [self refreshLayout];
//    CGFloat  height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    self.data.height = height;
//    return height;
//}


-(CGFloat)viewHeight{
    return 0;
}

-(CGFloat)viewWidth{
    return 0;
}

-(void)refresh{
    
}

-(UIView *)view{
    if (!_view) {
        _view = [QLXView createWithBgColor:[UIColor clearColor]];
        [self addSubview:_view];
        [_view constraintWithEdgeZero];
    }
    return _view;
}
@end
