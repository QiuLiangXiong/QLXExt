//
//  QLXTableViewCell.m
//  
//
//  Created by QLX on 15/8/8.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import "QLXTableViewCell.h"
#import "QLXExt.h"
@implementation QLXTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}


// 可以重写 可以不用重写
-(void) createUI{
    // 分割线 默认不现实
    self.highlightEnable = true;
    self.lineV = [UIView new];
    self.lineV.hidden = true;
    self.lineV.backgroundColor = [UIColor colorWithWhite:225/255.0 alpha:1];
    [self addSubview:self.lineV];
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(@0.3);
    }];
}
// 需要重写
-(void) reuseWithData:(ReuseDataBase *) data indexPath:(NSIndexPath *) indexPath{
    self.data = data;
    self.indexPath = indexPath;
}

-(CGFloat) cellHeight{
    assert(self.tableView);
    self.width = self.tableView.width;
    if (self.width == 0) {
        self.width = [UIScreen mainScreen].bounds.size.width;
    }
    [self refreshLayout];
    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    self.data.height = height;
    return height;
    
}

-(void) setSeparatorLineHidden{
    self.lineV.hidden = true;
}
-(void) setSeparatorLineShow{
    self.lineV.hidden = false;
}
-(void) setSeparatorLineShowWithInset:(UIEdgeInsets ) edgeInset{
    [self setSeparatorLineShow];
    [self.lineV mas_remakeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self).offset(-edgeInset.bottom);
        make.left.equalTo(self).offset(edgeInset.left);
        make.right.equalTo(self).offset(-edgeInset.right);
        make.height.mas_equalTo(@0.3);
    }];
}
-(void) setSeparatorLineColor:(UIColor *) color{
    self.lineV.backgroundColor = color;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
   
    if (selected) {
        if ([self.delegate respondsToSelector:@selector(tableViewCell:didSelect:)]) {
            [self.delegate tableViewCell:self didSelect:self.indexPath];
        }
    }
    if (selected) {
        selected = self.selectEnable;
    }
     [super setSelected:selected animated:false];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    if (highlighted) {
        if ([self.delegate respondsToSelector:@selector(tableViewCell:didHighlited:)]) {
            [self.delegate tableViewCell:self didHighlited:self.indexPath];
        }
    }
    if (highlighted) {
        highlighted = self.highlightEnable;
    }
    [super setHighlighted:highlighted animated:animated];
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



-(QLXTableView *)tableView{
    QLXTableView * view = _tableView;
    if (view &&  view.height == 0) {
        [view layoutIfNeeded];
        [view setNeedsLayout];
    }
    return view;
}

@end
