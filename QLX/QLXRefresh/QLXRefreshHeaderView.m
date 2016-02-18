//
//  QLXRefreshHeaderView.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/11.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXRefreshHeaderView.h"
#import "QLXExt.h"
@implementation QLXRefreshHeaderView


+ (instancetype)headerWithRefreshingBlock:(QLXRefreshingBlock)refreshingBlock
{
    QLXRefreshHeaderView *header = [[self alloc] init];
    header.refreshingBlock = refreshingBlock;
    return header;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    QLXRefreshHeaderView *header = [[self alloc] init];
    [header setRefreshingTarget:target refreshingAction:action];
    return header;
}
-(void)onEnter{
    [super onEnter];
    CGRect frame = self.scrollView.frame;
    if (self.refreshDirection == QLXRefreshDirectionVertical) {
        frame.size.height = self.viewHeight;
        frame.origin.y = - self.viewHeight;
        frame.origin.x = 0;
    }else if(self.refreshDirection == QLXRefreshDirectionHorizonal){
        frame.size.width = self.viewWidth;
        frame.origin.x = - self.viewWidth;
        frame.origin.y = 0;
    }else {
        assert(0); // 方向设置错误
    }
    self.frame = frame;
}

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    if (self.refreshDirection == QLXRefreshDirectionVertical) {
        [self scrollViewContentOffsetDidChangeForVertical:change];
    }else if(self.refreshDirection == QLXRefreshDirectionHorizonal){
        [self scrollViewContentOffsetDidChangeForHorizonal:change];
    }
}


-(void) scrollViewContentOffsetDidChangeForVertical:(NSDictionary *)change{
    if (self.state == QLXRefreshStateRefreshing) {   // 正在刷新中就不做操作了
        return ;
    }
    // 跳转到下一个控制器时，contentInset可能会变
    self.scrollViewOriginalInset = self.scrollView.contentInset;
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat happendY = - self.scrollViewOriginalInset.top;
    if (offsetY >= happendY) return; //向上拉就不管了
    
    // 普通 和 即将刷新 的临界点
    CGFloat normalAndPullingOffsetY = happendY - self.height;
    self.pullingOffset =  (happendY - offsetY);
    self.pullingPercent = self.pullingOffset / self.height;
    if (self.scrollView.isDragging) { // 如果正在拖拽
        if (self.state == QLXRefreshStateIdle && offsetY < normalAndPullingOffsetY) {
            // 转为即将刷新状态
            self.state = QLXRefreshStatePulling;
        } else if (self.state == QLXRefreshStatePulling && offsetY >= normalAndPullingOffsetY) {
            // 转为普通状态
            self.state = QLXRefreshStateIdle;
        }
    } else if (self.state == QLXRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    }
}


-(void) scrollViewContentOffsetDidChangeForHorizonal:(NSDictionary *)change{
    if (self.state == QLXRefreshStateRefreshing) {   // 正在刷新中就不做操作了
        return ;
    }
    // 跳转到下一个控制器时，contentInset可能会变
    self.scrollViewOriginalInset = self.scrollView.contentInset;
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat happendX = - self.scrollViewOriginalInset.left;
    if (offsetX >= happendX) return; //向上拉就不管了
    
    // 普通 和 即将刷新 的临界点
    CGFloat normalAndPullingOffsetX = happendX - self.width;
    self.pullingOffset =  (happendX - offsetX);
    self.pullingPercent = self.pullingOffset / self.width;
    if (self.scrollView.isDragging) { // 如果正在拖拽
        if (self.state == QLXRefreshStateIdle && offsetX < normalAndPullingOffsetX) {
            // 转为即将刷新状态
            self.state = QLXRefreshStatePulling;
        } else if (self.state == QLXRefreshStatePulling && offsetX >= normalAndPullingOffsetX) {
            // 转为普通状态
            self.state = QLXRefreshStateIdle;
        }
    } else if (self.state == QLXRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    }
}

-(void)setState:(QLXRefreshState)state{
    if (self.state == state) {
        return ;
    }
    if (self.refreshDirection == QLXRefreshDirectionVertical) {
        [self stateDidChangForVerticalWithState:state];
    }else if(self.refreshDirection == QLXRefreshDirectionHorizonal){
        [self stateDidChangForHorizonalWithState:state];
    }
    
    [super setState:state];
}

-(void) stateDidChangForVerticalWithState:(QLXRefreshState)state{
    // 根据状态做事情
    if (state == QLXRefreshStateIdle && self.state == QLXRefreshStateRefreshing) {
        // 恢复inset和offset
        if (self.animatedEnable) {
            [UIView animateWithDuration:0.4 animations:^{
                UIEdgeInsets insets = self.scrollView.contentInset;
                insets.top = insets.top - self.height;
                self.scrollView.contentInset = insets;
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
                self.pullingOffset = 0.0;
            }];
        }else {
            UIEdgeInsets insets = self.scrollView.contentInset;
            insets.top = insets.top - self.height;
            self.scrollView.contentInset = insets;
            self.pullingPercent = 0.0;
            self.pullingOffset = 0.0;
        }
        
    } else if (state == QLXRefreshStateRefreshing) {
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.top = self.scrollViewOriginalInset.top + self.height;
        
        //[self.scrollView setContentOffset:contentOff animated:true];
        if (self.animatedEnable) {
            [UIView animateWithDuration:0.4 animations:^{
                // 增加滚动区域
                self.scrollView.contentInset = insets;
                //设置滚动位置
                CGPoint contentOff = self.scrollView.contentOffset;
                contentOff.y = - insets.top;
                self.scrollView.contentOffset = contentOff;
            } completion:^(BOOL finished) {
                [self executeRefreshingCallBack];
            }];
        }else {
            // 增加滚动区域
            self.scrollView.contentInset = insets;
            //设置滚动位置
            CGPoint contentOff = self.scrollView.contentOffset;
            contentOff.y = - insets.top;
            self.scrollView.contentOffset = contentOff;
            [self executeRefreshingCallBack];
        }
        
        
    }
    
    
}
-(void) stateDidChangForHorizonalWithState:(QLXRefreshState)state{
    // 根据状态做事情
    if (state == QLXRefreshStateIdle && self.state == QLXRefreshStateRefreshing) {
        // 恢复inset和offset
        if (self.animatedEnable) {
            [UIView animateWithDuration:0.4 animations:^{
                UIEdgeInsets insets = self.scrollView.contentInset;
                insets.left = insets.left - self.width;
                self.scrollView.contentInset = insets;
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
                self.pullingOffset = 0.0;
            }];
        }else {
            UIEdgeInsets insets = self.scrollView.contentInset;
            insets.left = insets.left - self.width;
            self.scrollView.contentInset = insets;
            self.pullingPercent = 0.0;
            self.pullingOffset = 0.0;
        }
        
    } else if (state == QLXRefreshStateRefreshing) {
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.left = self.scrollViewOriginalInset.left + self.width;
        
        //[self.scrollView setContentOffset:contentOff animated:true];
        if (self.animatedEnable) {
            [UIView animateWithDuration:0.4 animations:^{
                // 增加滚动区域
                self.scrollView.contentInset = insets;
                //设置滚动位置
                CGPoint contentOff = self.scrollView.contentOffset;
                contentOff.x = - insets.left;
                self.scrollView.contentOffset = contentOff;
            } completion:^(BOOL finished) {
                [self executeRefreshingCallBack];
            }];
        }else {
            // 增加滚动区域
            self.scrollView.contentInset = insets;
            //设置滚动位置
            CGPoint contentOff = self.scrollView.contentOffset;
            contentOff.x = - insets.left;
            self.scrollView.contentOffset = contentOff;
            [self executeRefreshingCallBack];
        }
    }
}

//-(void)endRefreshingWithResult:(QLXRefreshResult)result{
//
//}

@end
