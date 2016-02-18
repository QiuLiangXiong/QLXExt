//
//  QLXMessageRefreshHeader.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/15.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXMessageRefreshHeader.h"
#import "QLXExt.h"
@interface QLXMessageRefreshHeader()

@property (nonatomic, strong) UIActivityIndicatorView * loading;
@property (nonatomic, strong) UIView * refreshView;

@end


@implementation QLXMessageRefreshHeader

-(instancetype)init{
    self = [super init];
    if (self) {
        self.viewHeight = 54;
    }
    return self;
}



-(UIView *)idleView{
    if (![super idleView]) {
        [super setIdleView:self.refreshView];
    }
    return [super idleView];
}

-(UIView *)pullingView{
    if (![super pullingView]) {
        [super setPullingView:self.refreshView];
    }
    return [super pullingView];
}

-(UIView *)refreshingView{
    if (![super refreshingView]) {
        [super setRefreshingView:self.refreshView];
    }
    return [super refreshingView];
}

-(void)refreshStateChange:(QLXRefreshState)state{
//    if (state == QLXRefreshStateRefreshing) {
//        [self.loading startAnimating];
//    }else {
//        [self.loading stopAnimating];
//    }
}

-(UIView *)refreshView{
    if (!_refreshView) {
        _refreshView = [QLXView createWithBgColor:[UIColor clearColor]];
        [_refreshView setClipsToBounds:false];
        
//        //line
//        
//        UIView * line = [QLXView createWithBgColor:[UIColor whiteColor]];
//        [_refreshView addSubview:line];
//        
//        [line mas_makeConstraints:^(MASConstraintMaker *make){
//            make.centerX.equalTo(_refreshView);
//            make.bottom.equalTo(_refreshView.mas_centerY);
//            make.width.mas_equalTo(@1);
//            make.height.mas_equalTo(@1000);
//        }];
        
       // line.layer.shadowColor = [UIColor grayColor].CGColor;
//        
//        //圆形
//        
//        UIView * circleBg = [QLXView createWithBgColor:[UIColor whiteColor]];
//        [_refreshView addSubview:circleBg];
//        
//        [circleBg mas_makeConstraints:^(MASConstraintMaker *make){
//            make.centerY.equalTo(_refreshView);
//            make.centerX.equalTo(_refreshView);
//            make.height.mas_equalTo(@30);
//            make.width.mas_equalTo(@30);
//        }];
//        
//        [circleBg setCornerWithRadius:15];
//        
        [_refreshView addSubview:self.loading];
        
        [self.loading mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(_refreshView);
            make.centerY.equalTo(_refreshView);
        }];
        [self.loading startAnimating];
    }
    return _refreshView;
}


-(UIActivityIndicatorView *)loading{
    if (!_loading) {
        _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    }
    return _loading;
}
@end
