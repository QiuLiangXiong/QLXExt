//
//  UIScrollView+QLXExt.m
//
//
//  Created by QLX on 15/9/13.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import "UIScrollView+QLXExt.h"
#import <objc/runtime.h>
#import "QLXExt.h"
#import "QLXRefreshFooter.h"
#import "QLXRefreshHeader.h"
@implementation UIScrollView(QLXExt)
-(void)setInsetTop:(CGFloat)insetTop{
    UIEdgeInsets inset = self.contentInset;
    inset.top = insetTop;
    self.contentInset = inset;
}

-(CGFloat)insetTop{
    return self.contentInset.top;
}

-(void)setInsetBottom:(CGFloat)insetBottom{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = insetBottom;
    self.contentInset = inset;
}

-(CGFloat)insetBottom{
    return self.contentInset.bottom;
}

-(void)setInsetLeft:(CGFloat)insetLeft{
    UIEdgeInsets inset = self.contentInset;
    inset.left = insetLeft;
    self.contentInset = inset;
}

-(CGFloat)insetLeft{
    return self.contentInset.left;
}

-(void)setInsetRight:(CGFloat)insetRight{
    UIEdgeInsets inset = self.contentInset;
    inset.right = insetRight;
    self.contentInset = inset;
}

-(CGFloat)insetRight{
    return self.contentInset.right;
}

-(void)setOffsetX:(CGFloat)offsetX{
    CGPoint offset = self.contentOffset;
    offset.x = offsetX;
    self.contentOffset = offset;
}

-(CGFloat)offsetX{
    return self.contentOffset.x;
}

-(void)setOffsetY:(CGFloat)offsetY{
    CGPoint offset = self.contentOffset;
    offset.y = offsetY;
    self.contentOffset = offset;
}

-(CGFloat)offsetY{
    return self.contentOffset.y;
}

-(void)setContentW:(CGFloat)contentW{
    CGSize size = self.contentSize;
    size.width = contentW;
    self.contentSize = size;
}

-(CGFloat)contentW{
    return self.contentSize.width;
}

-(void)setContentH:(CGFloat)contentH{
    CGSize size = self.contentSize;
    size.height = contentH;
    self.contentSize = size;
}

-(CGFloat)contentH{
    return self.contentSize.height;
}

#pragma mark - header
static const char QLXRefreshHeaderKey = '\0';
-(QLXRefreshHeaderView *)refreshHeader{
    return objc_getAssociatedObject(self, &QLXRefreshHeaderKey);
}

-(void)setRefreshHeader:(QLXRefreshHeaderView *)refreshHeader{
    if (refreshHeader != self.refreshHeader) {
        // 删除旧的，添加新的
        [self.refreshHeader removeFromSuperview];
        [self addSubview:refreshHeader];
        
        objc_setAssociatedObject(self, &QLXRefreshHeaderKey,
                                 refreshHeader, OBJC_ASSOCIATION_ASSIGN);
    }
}


#pragma mark - footer
static const char QLXRefreshFooterKey = '\0';

-(QLXRefreshFooterView *)refreshFooter{
    return objc_getAssociatedObject(self, &QLXRefreshFooterKey);
}

-(void)setRefreshFooter:(QLXRefreshFooterView *)refreshFooter{
    if (refreshFooter != self.refreshFooter) {
        [self.refreshFooter removeFromSuperview];
        [self addSubview:refreshFooter];
        
        objc_setAssociatedObject(self, &QLXRefreshFooterKey,
                                 refreshFooter, OBJC_ASSOCIATION_ASSIGN);
    }
}

-(void) removeRefreshFooter{
    self.refreshFooter = nil;
}

-(void) removeRefreshHeader{
    self.refreshHeader = nil;
}

-(void) hideRefreshHeader{
    self.refreshHeader.hidden = true;
}

-(void) hideRefreshFooter{
    self.refreshFooter.hidden = true;
}


-(void) addRefreshFooterWithTarget:(id)target refreshingAction:(SEL)action{
    self.refreshFooter = [QLXRefreshFooter footerWithRefreshingTarget:target refreshingAction:action];
}

-(void) addRefreshHeaderWithTarget:(id)target refreshingAction:(SEL)action{
    self.refreshHeader = [QLXRefreshHeader headerWithRefreshingTarget:target refreshingAction:action];
}

-(void) addRefreshFooterWithTarget:(id)target refreshingAction:(SEL)action footer:(QLXRefreshFooterView *) footer{
    self.refreshFooter = footer;
    [self.refreshFooter setRefreshingTarget:target refreshingAction:action];
}

-(void) addRefreshHeaderWithTarget:(id)target refreshingAction:(SEL)action header:(QLXRefreshHeaderView *) header{
    self.refreshHeader= header;
    [self.refreshHeader setRefreshingTarget:target refreshingAction:action];
}

-(void) headerBeginRefresh{
    [self.refreshHeader beginRefreshing];
}

-(void) footerBeginRefresh{
    [self.refreshFooter beginRefreshing];
}

-(void) headerEndRefreshingWithResult:(QLXRefreshResult) result{
    [self.refreshHeader endRefreshingWithResult:result];
}

-(void) footerEndRefreshingWithResult:(QLXRefreshResult) result{
    [self.refreshFooter endRefreshingWithResult:result];
}

-(void) endRefreshingWithResult:(QLXRefreshResult) result{
    if ([self.refreshFooter isRefreshing]) {
        [self footerEndRefreshingWithResult:result];
    }
    if ([self.refreshHeader isRefreshing]) {
        [self headerEndRefreshingWithResult:result];
    }
}


-(void)onExit{
    [super onExit];
    self.refreshHeader = nil;
    self.refreshFooter = nil;
}

-(void)onEnter{
    [super onEnter];
    self.delaysContentTouches = NO;
}
@end
