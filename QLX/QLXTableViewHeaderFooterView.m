//
//  QLXTableViewHeaderFooterView.m
//  
//
//  Created by QLX on 15/8/8.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import "QLXTableViewHeaderFooterView.h"
#import "QLXExt.h"
@implementation QLXTableViewHeaderFooterView

+(instancetype) create{
    return [[self alloc] initWithReuseIdentifier:[self className]];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
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


-(CGFloat) viewHeight{
    self.width = self.tableView.width;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGFloat  height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.data.height = height;
    
    if (height == 0) {
        height = 0.001;
    }
    return height;
}

-(void)refresh{
    
}

-(UIView *)view{
    if (!_view) {
        _view = [QLXView createWithBgColor:[UIColor clearColor]];
        [self.contentView addSubview:_view];
        [_view constraintWithEdgeZero];
    }
    return _view;
}


@end
