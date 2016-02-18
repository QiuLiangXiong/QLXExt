//
//  QLXRefreshFooterView.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/11.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXRefreshFooterView.h"
#import "QLXExt.h"

@interface QLXRefreshFooterView()

@property (nonatomic, assign) BOOL increaseBottomInseted;   // 底部偏移了吗

@end

@implementation QLXRefreshFooterView

+ (instancetype)footerWithRefreshingBlock:(QLXRefreshingBlock)refreshingBlock
{
    QLXRefreshFooterView *footer = [[self alloc] init];
    footer.refreshingBlock = refreshingBlock;
    return footer;
}

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    QLXRefreshFooterView *footer = [[self alloc] init];
    [footer setRefreshingTarget:target refreshingAction:action];
    return footer;
}

-(void)onEnter{
    [super onEnter];
    CGRect frame = self.scrollView.frame;
    
    if (self.refreshDirection == QLXRefreshDirectionVertical) {
        frame.size.height = self.viewHeight;
        frame.origin.y = self.scrollView.contentH;
        frame.origin.x = 0;
    }else if(self.refreshDirection == QLXRefreshDirectionHorizonal){
        frame.size.width = self.viewWidth;
        frame.origin.x = self.scrollView.contentW;
        frame.origin.y = 0;
    }
    self.frame = frame;
    [self addSubview:self.failView];
    [self addSubview:self.noMoreDataView];
}

-(void) onExit{
    [super onExit];
    [self setHidden:true];
}

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    if (self.refreshDirection == QLXRefreshDirectionVertical) {
        [self scrollViewContentOffsetDidChangeForVertical:change];
    }else if(self.refreshDirection == QLXRefreshDirectionHorizonal){
        [self scrollViewContentOffsetDidChangeForHorizal:change];
    }
}

-(void) scrollViewContentOffsetDidChangeForVertical:(NSDictionary *)change{
    
    // 如果正在刷新，直接返回
    if (self.state == QLXRefreshStateRefreshing || self.height == 0 || self.noMoreDataView.hidden == false) return;
    UIScrollView * scrollView = self.scrollView;
    if (scrollView.insetTop + scrollView.contentH > scrollView.height) { // 内容超过一个屏幕
        // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
        if (scrollView.offsetY > scrollView.contentH - scrollView.height +scrollView.insetBottom - self.preRefreshDistance) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

-(void) scrollViewContentOffsetDidChangeForHorizal:(NSDictionary *)change{
    // 如果正在刷新，直接返回
    if (self.state == QLXRefreshStateRefreshing || self.width == 0 || self.resultState == QLXRefreshResultNoMoreData) return;
    UIScrollView * scrollView = self.scrollView;
    if (scrollView.insetLeft + scrollView.contentW > scrollView.width) { // 内容超过一个屏幕
        // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
        if (scrollView.offsetX > scrollView.contentW - scrollView.width +scrollView.insetRight - self.preRefreshDistance) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.x <= old.x) return;
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    if (self.refreshDirection == QLXRefreshDirectionVertical) {
        [self scrollViewPanStateDidChangeForVertical:change];
    }else if(self.refreshDirection == QLXRefreshDirectionHorizonal){
        [self scrollViewPanStateDidChangeForHorizal:change];
    }
}

- (void)scrollViewPanStateDidChangeForVertical:(NSDictionary *)change{
    if (self.state != QLXRefreshStateIdle ||  self.noMoreDataView.hidden == false) return;
    UIScrollView * scrollView = self.scrollView;
    if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (scrollView.insetTop + scrollView.contentH <= scrollView.height) {  // 不够一个屏幕
            if (scrollView.offsetY > - scrollView.insetTop) { // 向上拽
                [self beginRefreshing];
            }
        } else { // 超出一个屏幕
            if (scrollView.offsetY > scrollView.contentH + scrollView.insetBottom - scrollView.height) {
                [self beginRefreshing];
            }
        }
    }
}

- (void)scrollViewPanStateDidChangeForHorizal:(NSDictionary *)change{
    if (self.state != QLXRefreshStateIdle ||  self.noMoreDataView.hidden == false) return;
    UIScrollView * scrollView = self.scrollView;
    if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (scrollView.insetLeft + scrollView.contentW <= scrollView.width) {  // 不够一个屏幕
            if (scrollView.offsetX > - scrollView.insetLeft) { // 向上拽
                [self beginRefreshing];
            }
        } else { // 超出一个屏幕
            if (scrollView.offsetX > scrollView.contentW + scrollView.insetRight - scrollView.width) {
                [self beginRefreshing];
            }
        }
    }
}

- (void)setState:(QLXRefreshState)state
{
    if (self.state == state) {
        return ;
    }
    if (state == QLXRefreshStateRefreshing) {
        // 这里延迟是防止惯性导致连续上拉
        [GCDQueue executeInMainQueue:^{
            [self executeRefreshingCallBack];
        } afterDelaySecs:0.5];
    }
    [super setState:state];
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    // 设置位置
    if (self.refreshDirection == QLXRefreshDirectionVertical) {
        self.y = self.scrollView.contentH;
        if (self.scrollView.contentH < self.scrollView.height) {
            self.hidden = true;
        }else {
            self.hidden = false;
        }
    }else if(self.refreshDirection == QLXRefreshDirectionHorizonal){
        self.x = self.scrollView.contentW;
        if (self.scrollView.contentW < self.scrollView.width) {
            self.hidden = true;
        }else {
            self.hidden = false;
        }
    }
}

- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if (self.refreshDirection == QLXRefreshDirectionVertical) {
        [self setHiddenForVertical:hidden];
    }else {
        [self setHiddenForHorizal:hidden];
    }
}

- (void)setHiddenForVertical:(BOOL)hidden{
    if (hidden) {
        if (self.increaseBottomInseted) {
            self.increaseBottomInseted = false;
            self.scrollView.insetBottom -= self.viewHeight;
        }
    }else {
        if (self.increaseBottomInseted == false) {
            self.increaseBottomInseted = true;
            self.scrollView.insetBottom += self.viewHeight;
        }
    }
}
- (void)setHiddenForHorizal:(BOOL)hidden{
    if (hidden) {
        if (self.increaseBottomInseted) {
            self.increaseBottomInseted = false;
            self.scrollView.insetRight -= self.viewWidth;
        }
    }else {
        if (self.increaseBottomInseted == false) {
            self.increaseBottomInseted = true;
            self.scrollView.insetRight += self.viewWidth;
        }
    }
}

-(void) endRefreshingWithResult:(QLXRefreshResult) result{
    [super endRefreshingWithResult:result];
    [self hideSubViews];
    switch (result) {
        case QLXRefreshResultSuccess:
        {
            self.idleView.hidden = false;
            break;
        }
        case QLXRefreshResultFail:
        {
            if (self.failView) {
                [self hideSubViews];
                self.failView.hidden = false;
            }
            break;
        }
        case QLXRefreshResultNoMoreData:
        {
            if (self.noMoreDataView) {
                [self hideSubViews];
                self.noMoreDataView.hidden = false;
            }
            break;
        }
        default:
            break;
    }
}
@end
