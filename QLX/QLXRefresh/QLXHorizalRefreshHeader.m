//
//  QLXHorizalRefreshHeader.m
//  fcuhConsumer
//
//  Created by QLX on 16/1/28.
//  Copyright © 2016年 avatar. All rights reserved.
//

#import "QLXHorizalRefreshHeader.h"
#import "QLXExt.h"

@interface QLXHorizalRefreshHeader()

@property(nonatomic , strong)  UIView * rootView;
@property(nonatomic , strong)  UIActivityIndicatorView * loadingView;

@end
@implementation QLXHorizalRefreshHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewWidth = 64;
        self.refreshDirection = QLXRefreshDirectionHorizonal; //  设置为横向刷新方向
    }
    return self;
}


-(void)refreshStateChange:(QLXRefreshState)state{
    switch (state) {
        case QLXRefreshStateIdle:
        {
//            self.stateLbl.text = @"下拉即可刷新";
            [self.loadingView stopAnimating];
            break;
        }
        case QLXRefreshStatePulling:
        {
//            self.stateLbl.text = @"松开立即刷新";
            [self.loadingView stopAnimating];
            break;
        }
        case QLXRefreshStateRefreshing:
        {
//            self.stateLbl.text = @"努力刷新中...";
            [self.loadingView startAnimating];
            break;
        }
        default:
            break;
    }
}

-(UIView *)idleView{
    if (![super idleView]) {
        [super setIdleView:self.rootView];
    }
    return [super idleView];
}

-(UIView *)pullingView{
    if (![super pullingView]) {
        [super setPullingView:self.rootView];
    }
    return [super pullingView];
}

-(UIView *)refreshingView{
    if (![super refreshingView]) {
        [super setRefreshingView:self.rootView];
    }
    return [super refreshingView];
}


-(UIView *)rootView{
    if (!_rootView) {
        _rootView = [UIView new];
        _rootView.backgroundColor = [UIColor clearColor];
        [self addSubview:_rootView];
    }
    return _rootView;
}

-(UIActivityIndicatorView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        _loadingView.hidesWhenStopped = false;
        [self.rootView addSubview:_loadingView];
    }
    return _loadingView;
}

-(void)onEnter{
    [super onEnter];
    self.rootView.frame = self.bounds;
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.rootView);
    }];
}


@end
