//
//  QLXRefreshHeader.m
//  头部刷新控件
//
//  Created by QLX on 15/9/13.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import "QLXRefreshHeader.h"
#import "QLXExt.h"
@interface QLXRefreshHeader()
@property (strong, nonatomic) UIImageView *loadingView;
@property (nonatomic, strong) UILabel * stateLbl;
@property (nonatomic, strong) UILabel * lastTimeLbl;
@property (nonatomic, strong) UILabel * lastTimeInfoLbl;
@property (nonatomic, strong) UIView * bg;
@property (nonatomic, strong) UIView * rootView;
@property (nonatomic, copy) NSString * lastTimeKey;

@end
@implementation QLXRefreshHeader

-(instancetype)init{
    self = [super init];
    if (self) {
        self.viewHeight = 44;
    }
    return self;
}

-(void)refreshStateChange:(QLXRefreshState)state{
    switch (state) {
        case QLXRefreshStateIdle:
        {
            self.stateLbl.text = @"下拉即可刷新";
            [self.loadingView stopAnimating];
            break;
        }
        case QLXRefreshStatePulling:
        {
            self.stateLbl.text = @"松开立即刷新";
            [self.loadingView stopAnimating];
            break;
        }
        case QLXRefreshStateRefreshing:
        {
            self.stateLbl.text = @"努力刷新中...";
            [self.loadingView startAnimating];
            break;
        }
        default:
            break;
    }
}

//-(void) endRefreshingWithResult:(QLXRefreshResult)result{
//    [super endRefreshingWithResult:result];
//    if (result == QLXRefreshResultSuccess || result == QLXRefreshResultNoMoreData) {
////        // 保存刷新时间
////        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[self lastTimeKey]];
////        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//}
//
//-(void)setPullingOffset:(CGFloat)pullingOffset{
////    if (self.pullingOffset <= 1 && pullingOffset > 1) {
////        self.lastTimeInfoLbl.text = [self getLastRefreshTime];
////    }
//    [super setPullingOffset:pullingOffset];
//}

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

-(UIView *) getRefreshView{
    // 状态
    [self.stateLbl mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.bg);

    }];
    //菊花
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.bg);
        make.right.equalTo(self.bg.mas_centerX).offset(-90);
    }];
    
//    [self.lastTimeLbl mas_makeConstraints:^(MASConstraintMaker *make){
//        make.bottom.equalTo(self.bg);
//        make.height.equalTo(self.bg).multipliedBy(0.5);
//        make.right.equalTo(self.bg.mas_centerX);
//    }];
//    
//    [self.lastTimeInfoLbl mas_makeConstraints:^(MASConstraintMaker *make){
//        make.bottom.equalTo(self.bg);
//        make.height.equalTo(self.bg).multipliedBy(0.5);
//        make.left.equalTo(self.bg.mas_centerX);
//    }];
    
    
    return self.bg;
}

-(UILabel *)stateLbl{
    if (!_stateLbl) {
        UIColor * color = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
        _stateLbl = [UILabel createWithText:@"下拉即可刷新" color:color fontSize:15];
        _stateLbl.font = [UIFont boldSystemFontOfSize:14];
        [self.bg addSubview:_stateLbl];
    }
    return _stateLbl;
}

-(UIView *)bg{
    if (!_bg) {
        _bg = [QLXView createWithBgColor:[UIColor clearColor]];
    }
    return _bg;
}

-(UIView *)rootView{
    if (!_rootView) {
        _rootView = [self getRefreshView];
    }
    return _rootView;
}

- (UIImageView *)loadingView{
    if (!_loadingView) {
        _loadingView = [UIImageView new];
        _loadingView.animationImages = [self getRefreshGifImages];
        _loadingView.animationDuration = 1.2;
        _loadingView.image = [_loadingView.animationImages objectAtIndex:0];
        [self.bg addSubview:_loadingView];
    }
    return _loadingView;
}

-(NSMutableArray *) getRefreshGifImages{
    // 设置刷新状态的动画图片
    NSMutableArray * images = [NSMutableArray array];
    for (NSUInteger i = 1; i<=12; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%lu", (unsigned long)i]];
        [images addObject:image];
    }
    return images;
}

-(UILabel *)lastTimeLbl{
    if (!_lastTimeLbl) {
        UIColor * color = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
        _lastTimeLbl = [UILabel createWithText:@"最后更新: " color:color];
        _lastTimeLbl.font = [UIFont boldSystemFontOfSize:14];
        [self.bg addSubview:_lastTimeLbl];
      }
    return _lastTimeLbl;
}

-(UILabel *)lastTimeInfoLbl{
    if (!_lastTimeInfoLbl) {
        UIColor * color = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
        _lastTimeInfoLbl = [UILabel createWithText:@"今天 11:56" color:color];
        _lastTimeInfoLbl.font = [UIFont boldSystemFontOfSize:14];
        [self.bg addSubview:_lastTimeInfoLbl];
    }
    return _lastTimeInfoLbl;
}

-(NSString *) getLastRefreshTime{
    NSString * lastTime = @"无记录";
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:[self lastTimeKey]];
    if (lastUpdatedTime) {
//        // 1.获得年月日
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
//        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
//        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
//        
//        // 2.格式化日期
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        if ([cmp1 day] == [cmp2 day]) { // 今天
//            formatter.dateFormat = @"今天 HH:mm";
//        } else if ([cmp1 year] == [cmp2 year]) { // 今年
//            formatter.dateFormat = @"MM-dd HH:mm";
//        } else {
//            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
//        }
//        NSString *time = [formatter stringFromDate:lastUpdatedTime];
//        
//        // 3.显示日期
//        lastTime = [NSString stringWithFormat:@"%@", time];
        lastTime = [NSDate timeInfoWithData:lastUpdatedTime];
    }
    return lastTime;
}

-(NSString *)lastTimeKey{
    if (!_lastTimeKey) {
        _lastTimeKey = [NSString stringWithFormat:@"%@_QLXRefreshHeaderLastTimeKey",   [[self viewController] className]];
    }
    return _lastTimeKey;
}
@end
