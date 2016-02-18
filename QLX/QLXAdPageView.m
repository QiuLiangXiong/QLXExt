//
//  QLXAdPageView.m
//  QLXExtDemo
//
//  Created by QLX on 15/11/1.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXAdPageView.h"
#import "QLXPageControl.h"
#import "QLXExt.h"

@interface QLXAdPageView()<QLXPageViewDelegate>

@property(nonatomic , strong) QLXPageView * pageView;

@property(nonatomic , strong) NSMutableArray * dataList;

@end

@implementation QLXAdPageView

@synthesize curPage = _curPage;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}

-(void)initConfig{
    self.backgroundColor = [UIColor clearColor];
    self.adEnable = true;
    [self.pageView constraintWithEdgeZero];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).multipliedBy(1.5);
    }];
}

-(void)onEnter{
    [super onEnter];
    
    if (self.pageView.curPage == 0 && self.dataList.count > 1) {
        self.curPage = 0;
    }
}

-(void)setDotNormalImage:(UIImage *)dotNormalImage{
    self.pageControl.normalImage = dotNormalImage;
}

-(void)setDotSelectedImage:(UIImage *)dotSelectedImage{
    self.pageControl.selectedImage = dotSelectedImage;
}

-(void)reloadData{
    self.dataList = nil;
    [self.pageView reloadData];
}

// 分页
-(QLXPageView *)pageView{
    if (!_pageView) {
        _pageView = [QLXPageView new];
        _pageView.pageViewDelegate = self;
        [self addSubview:_pageView];
    }
    return _pageView;
}

-(void)setPageDotsHidden:(BOOL)pageDotsHidden{
    if (pageDotsHidden) {
        self.pageControl.alpha = 0;
    }else {
        self.pageControl.alpha = 1;
    }
}

-(NSInteger)curPage{
    NSInteger pageIndex = self.pageView.curPage;
    if (self.dataList.count > 1) {
        if (pageIndex == self.dataList.count - 1) {
            pageIndex = 1;
        }
        if (pageIndex == 0) {
            pageIndex = self.dataList.count - 2;
        }
    }
    return pageIndex;
}

-(void)setCurPage:(NSInteger)curPage {
    [self setCurPage:curPage animated:true];
}

-(void)setCurPage:(NSInteger)curPage animated:(BOOL) animated{
    if (self.dataList.count > 1) {
        curPage += 1;
    }
    [self.pageView setCurPage:curPage animated:animated];
}


// 小圆点
-(QLXPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [QLXPageControl new];
        _pageControl.hidesForSinglePage = true;
        _pageControl.userInteractionEnabled = false;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}



#pragma mark - QLXPageViewDelegate

-(NSMutableArray *)pageDataListWithPageView:(QLXPageView *)pageView{
    return self.dataList;
}


-(void)pageView:(QLXPageView *)pageView pageChanged:(NSInteger)pageIndex{
    [self updatePageControlSelectedWithIndex:pageIndex];
}
#pragma mark - QLXPageViewDelegate
// 更新位置
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentW > scrollView.width) {
        if (scrollView.offsetX  >= scrollView.contentW - scrollView.width) {
            scrollView.offsetX = self.width;
        }else if(scrollView.offsetX <= 0){
            scrollView.offsetX = scrollView.contentW - 2 *scrollView.width;
        }
    }
}


// 数据加工
-(NSMutableArray *)dataList{
    if (!_dataList ) {
        if ([self.delegate respondsToSelector:@selector(pageDataListWithPageView:)]) {
            _dataList = [NSMutableArray new];
            NSMutableArray * rawDataList = [self.delegate pageDataListWithPageView:self];
            if (rawDataList.count > 1) {
                [_dataList addObject:[rawDataList lastObject]];
            }
            [_dataList addObjectsFromArray:rawDataList];
            if (rawDataList.count > 1) {
                [_dataList addObject:rawDataList.firstObject];
            }
            self.pageControl.currentPage = 0;
            self.pageControl.numberOfPages = rawDataList.count;
        }
    }
    return _dataList;
}


// 更新点的选择
-(void) updatePageControlSelectedWithIndex:(NSInteger) index{
    
    if (!self.pageControl.firstEnter) {
        kBlockWeakSelf;
        [GCDQueue executeInMainQueue:^{
            [weakSelf updatePageControlSelectedWithIndex:index];
        } afterDelaySecs:0];
        return;
    }
    
    self.pageControl.numberOfPages = [self.delegate pageDataListWithPageView:self].count;
    if (self.pageControl.numberOfPages > 1) {
        if (index == 0) {
            self.pageControl.currentPage = self.pageControl.numberOfPages - 1;
        }else if(index == self.pageControl.numberOfPages + 1){
            self.pageControl.currentPage = 0;
        }else {
            self.pageControl.currentPage = index - 1;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(adPageView:pageChanged:)]) {
        [self.delegate adPageView:self pageChanged:self.pageControl.currentPage];;
    }
}

-(void)setAdEnable:(BOOL)adEnable{
    _adEnable = adEnable;
    if (adEnable) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
        [self performSelector:@selector(autoMoveNextPage) withObject:nil afterDelay:2];
    }else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
    }
}

-(void) autoMoveNextPage{
    if (self.adEnable && self.dataList.count > 1) {
        if(self.pageView.decelerating == false && self.pageView.tracking == false ){
            NSInteger next = (self.pageControl.currentPage + 1) % self.pageControl.numberOfPages;
            self.pageControl.currentPage = next;
            NSInteger nextPage = self.pageView.curPage + 1;
            if (nextPage == self.dataList.count ) {
                nextPage = 2;
            }
            [self.pageView setCurPage: nextPage  animated:true];
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
        [self performSelector:@selector(autoMoveNextPage) withObject:nil afterDelay:2];
    }
}

-(void)onExit{
    [super onExit];
    if (self.adEnable) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
    }
}

#pragma QLXPageViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.adEnable) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
        [self performSelector:@selector(autoMoveNextPage) withObject:nil afterDelay:2];
    }
}


-(void)pageView:(QLXPageView *)pageView scrollPageProgress:(CGFloat)progress fromPage:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(pageView:scrollPageProgress:fromPage:)]) {
        [self.delegate adPageView:self scrollPageProgress:progress fromPage:index - 1];
    }
}


//  滚动到下一页
-(void) scrollToNextPage{
    if (!self.pageView.collectionView.scrolling ) {
        NSInteger nextPage = (self.pageView.curPage + 1) % self.dataList.count;
        [self.pageView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:nextPage inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:true];
    }
    
}

// 滚动到上一页
-(void) scrollToLastPage{
    if (!self.pageView.collectionView.scrolling ){
        NSInteger lastPage = (self.dataList.count +  self.pageView.curPage - 1) % self.dataList.count;
        [self.pageView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:lastPage inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:true];
    }
}









@end
