//
//  QLXRefreshBaseView.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/11.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXRefreshBaseView.h"
#import "QLXExt.h"
@implementation QLXRefreshBaseView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initConfigs];
    }
    return self;
}

-(void) initConfigs{
    self.viewHeight = Refresh_Height;
    self.clipsToBounds = false;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.idleView];
    [self addSubview:self.pullingView];
    [self addSubview:self.refreshingView];
    self.state = QLXRefreshStateIdle;
    self.animatedEnable = true;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    //[self removeObserver];
    if (newSuperview) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.scrollViewOriginalInset = self.scrollView.contentInset;
        [self addObserver];
    }
    
}

-(void) addObserver{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:Refresh_ContentSize options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:Refresh_ContentOffset options:options context:nil];
    [self.scrollView.panGestureRecognizer addObserver:self forKeyPath:Refresh_State options:options context:nil];
}

-(void) removeObserver{
    [self.scrollView removeObserver:self forKeyPath:Refresh_ContentSize];
     [self.scrollView removeObserver:self forKeyPath:Refresh_ContentOffset];
    [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:Refresh_State];
    self.refreshingBlock = nil;
}

-(void) onExit{
    [self removeObserver];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (!self.userInteractionEnabled || (self.hidden && ![keyPath isEqualToString:Refresh_ContentSize])) return;
    if ([keyPath isEqualToString:Refresh_ContentSize]){
        [self scrollViewContentSizeDidChange:change];
    }else if([keyPath isEqualToString:Refresh_ContentOffset]){
        [self scrollViewContentOffsetDidChange:change];
    }else if([keyPath isEqualToString:Refresh_State]){
        [self scrollViewPanStateDidChange:change];
        
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
}

#pragma mark 设置回调对象和回调方法
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    self.refreshingTarget = target;
    self.refreshingAction = action;
}

#pragma mark 进入刷新状态
- (void)beginRefreshing
{
    if (self.window) {
        self.state = QLXRefreshStateRefreshing;
    } else {
        self.state = QLXRefreshStateWillRefresh;
        // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
        [self setNeedsDisplay];
    }
}

#pragma mark 结束刷新状态
- (void)endRefreshing
{
    self.state = QLXRefreshStateIdle;
}


-(void) endRefreshingWithResult:(QLXRefreshResult) result{
    [self endRefreshing];
    self.resultState = result;
}

-(void)endRefreshingWithResult:(QLXRefreshResult)result animated:(BOOL)animated{
    BOOL last = self.animatedEnable;
    self.animatedEnable = animated;
    [self endRefreshingWithResult:result];
    self.animatedEnable = last;
}

#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return self.state == QLXRefreshStateRefreshing || self.state == QLXRefreshStateWillRefresh;
}

// 和 [self setNeedsDisplay]; 配套
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (self.state == QLXRefreshStateWillRefresh) {
        self.state = QLXRefreshStateRefreshing;
    }
}

-(void)addSubview:(UIView *)view{
    if (view.superview == nil) {
        [super addSubview:view];
        view.hidden = true;
        [view remakeConstraintWithEdge:UIEdgeInsetsZero];
    }
}

-(void)setState:(QLXRefreshState)state{
    if (_state == state) {
        return ;
    }
    _state = state;
    [self refreshStateChange:state];
    [self hideSubViews];
    switch (state) {
        case QLXRefreshStateIdle:
        {
            self.idleView.hidden = false;
            break;
        }
        case QLXRefreshStateRefreshing:
        {
            self.refreshingView.hidden = false;
            break;
        }
        case QLXRefreshStatePulling:
        {
            self.pullingView.hidden = false;
            break;
        }
        default:
            break;
    }
   
}

-(void) refreshStateChange:(QLXRefreshState) state{
    
}


-(void)executeRefreshingCallBack{
    [GCDQueue executeInMainQueue:^{
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
            msgSend(msgTarget(self.refreshingTarget), self.refreshingAction, self);
        }
    }];
}


@end
