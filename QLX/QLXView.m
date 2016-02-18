//
//  QLXView.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/21.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXView.h"
#import "QLXExt.h"
@interface QLXView()

@end
@implementation QLXView


+(QLXView *) create{
    return [QLXView new];
}

+(QLXView *) createWithBgColor:(UIColor *) color{
    QLXView * view = [QLXView new];
    view.backgroundColor = color;
    return view;
}


-(UIView *)topLine{
    if (!_topLine) {
        _topLine = [UIView new];
        [self addSubview:_topLine];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"#d0d0d0"];
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(@1);
        }];
    }
    return _topLine;
}

-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        [self addSubview:_bottomLine];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"#d0d0d0"];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(@1);
        }];
    }
    return _bottomLine;
}
-(UIView *)leftLine{
    if (!_leftLine) {
        _leftLine = [UIView new];
        [self addSubview:_leftLine];
        _leftLine.backgroundColor = [UIColor colorWithHexString:@"#d0d0d0"];
        [_leftLine mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(@1);
        }];
    }
    return _leftLine;
}

-(UIView *)rightLine{
    if (!_rightLine) {
        _rightLine = [UIView new];
        [self addSubview:_rightLine];
        _rightLine.backgroundColor = [UIColor colorWithHexString:@"#d0d0d0"];
        [_rightLine mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(@1);
        }];
    }
    return _rightLine;
}

-(UIView *)wrapView{
    if (!_wrapView) {
        _wrapView = [UIView new];
        _wrapView.backgroundColor = [UIColor clearColor];
        [self addSubview:_wrapView];
        [_wrapView sendToBack];
        _wrapView.frame = self.bounds;
        //[_wrapView constraintWithEdgeZero];
    }
    return _wrapView;
}

-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
}

-(UIView *)mask{
    if (!_mask) {
        _mask = [QLXView createWithBgColor:[UIColor blackColor]];
        _mask.alpha = 0.5;
    }
    if (_mask.superview == nil) {
        [self addSubview:_mask];
    }
    _mask.frame = self.bounds;
    [_mask bringToFront];
    return _mask;
}

//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    BOOL result = [super pointInside:point withEvent:event];
//    if (!result) {
//        result = CGRectContainsPoint([self viewController].navigationBar.frame, point);
//    }
//    return result;
//}
@end
