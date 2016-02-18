//
//  QLXRefreshFooter.m
//  
//
//  Created by QLX on 15/9/13.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import "QLXRefreshFooter.h"
#import "QLXExt.h"
@interface QLXRefreshFooter()
@property (nonatomic, strong) UIActivityIndicatorView * loading;
@end
@implementation QLXRefreshFooter
//NSString *const MJRefreshAutoFooterIdleText = @"点击或上拉加载更多";
//NSString *const MJRefreshAutoFooterRefreshingText = @"加载中，请稍候...";
//NSString *const MJRefreshAutoFooterNoMoreDataText = @"亲,没有更多数据了哦";

-(instancetype)init{
    self = [super init];
    if (self) {
        self.viewHeight = 44;
    }
    return self;
}

-(void) onLoadMore{
    if (self.state == QLXRefreshStateIdle) {
        [self beginRefreshing];
    }
}

-(void)refreshStateChange:(QLXRefreshState)state{
    if (state == QLXRefreshStateRefreshing) {
        [self.loading startAnimating];
    }else {
        [self.loading stopAnimating];
    }
}
-(UIView *)idleView{
    if (![super idleView]) {
        UIView * view = [self getRefreshViewWithStateText:@"点击或上拉加载更多"];
        [view addTapGestureRecognizerWithTarget:self action:@selector(onLoadMore)];
        [super setIdleView:view];
    }
    return [super idleView];
}

-(UIView *)refreshingView{
    if (![super refreshingView]) {
        UIView * view = [self getRefreshViewWithStateText:@"加载中，请稍候..."];
        UIActivityIndicatorView * loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        [view addSubview:loading];
        [loading mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(view);
            make.centerX.equalTo(view).offset(-100);
        }];
        loading.hidesWhenStopped = true;
        self.loading = loading;
        [super setRefreshingView:view];
    }
    return [super refreshingView];
}

-(UIView *)noMoreDataView{
    if (![super noMoreDataView]) {
        UIView * view = [self getRefreshViewWithStateText:@"亲,没有更多数据了哦"];
        [super setNoMoreDataView:view];
    }
    return [super noMoreDataView];
}


-(UIView *) getRefreshViewWithStateText:(NSString *)text{
    UIView * bg = [QLXView createWithBgColor:[UIColor clearColor]];
    
    UIColor * color = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
    UILabel * stateLbl = [UILabel createWithText:text color:color];
    stateLbl.font = [UIFont boldSystemFontOfSize:14];
    [bg addSubview:stateLbl];
    
    [stateLbl mas_makeConstraints:^(MASConstraintMaker *make){
        // 状态
            make.top.equalTo(bg);
            make.height.equalTo(bg);
            make.centerX.equalTo(bg);
    }];
    return bg;
}


//-(NSMutableArray *) getRefreshGifImages{
//    // 设置刷新状态的动画图片
//    NSMutableArray * images = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=12; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%lu", (unsigned long)i]];
//        [images addObject:image];
//    }
//    return images;
//}
@end
