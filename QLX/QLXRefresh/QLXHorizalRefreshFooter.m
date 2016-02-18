//
//  QLXHorizalRefreshFooter.m
//  fcuhConsumer
//
//  Created by QLX on 16/1/28.
//  Copyright © 2016年 avatar. All rights reserved.
//

#import "QLXHorizalRefreshFooter.h"
#import "QLXExt.h"

@interface QLXHorizalRefreshFooter()

@property (nonatomic, strong) UIActivityIndicatorView * loading;
@property(nonatomic , strong) UIView * refreshView;

@end

@implementation QLXHorizalRefreshFooter

-(instancetype)init{
    self = [super init];
    if (self) {
        self.viewWidth = 44;
        self.refreshDirection = QLXRefreshDirectionHorizonal;
    }
    return self;
}

//-(void) onLoadMore{
//    if (self.state == QLXRefreshStateIdle) {
//        [self beginRefreshing];
//    }
//}

-(void)refreshStateChange:(QLXRefreshState)state{
    if (state == QLXRefreshStateRefreshing) {
        [self.loading startAnimating];
    }else {
        [self.loading stopAnimating];
    }
}

// @override

-(UIView *)idleView{
    if (![super idleView]) {
        UIView * view = [self getRefreshViewWithStateText:@""];
        //[view addTapGestureRecognizerWithTarget:self action:@selector(onLoadMore)];
        [super setIdleView:view];
    }
    return [super idleView];
}
// @override

-(UIView *)refreshingView{
    if (![super refreshingView]) {
        UIView * view = [self getRefreshViewWithStateText:@""];
        [super setRefreshingView:view];
    }
    return [super refreshingView];
}
// @override

-(UIView *)noMoreDataView{
    if (![super noMoreDataView]) {
        UIView * view = [self getRefreshViewWithStateText:@""];
        [super setNoMoreDataView:view];
    }
    return [super noMoreDataView];
}


// make view


-(UIView *) getRefreshViewWithStateText:(NSString *)text{
    return self.refreshView;
}


-(UIActivityIndicatorView *)loading{
    if (!_loading) {
        _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        _loading.hidesWhenStopped = false;
    }
    return _loading;
}


-(UIView *)refreshView{
    if (!_refreshView) {
        _refreshView = [QLXView createWithBgColor:[UIColor clearColor]];
        [_refreshView addSubview:self.loading];
        [self.loading mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_refreshView);
        }];
    }
    return _refreshView;
}

//-(void)onEnter{
//    [super onEnter];
//    self.refreshingView.frame = self.bounds;
//}

@end
