//
//  QLXPageView.m
//  QLXExtDemo
//
//  Created by QLX on 15/10/29.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXPageView.h"
#import "QLXExt.h"
#import "QLXStaticPageCellData.h"

@interface QLXPageView()<QLXCollectionViewDelegate , QLXCollectionViewDataSourceDelegate>

@property (nonatomic , strong) NSMutableArray * dataList;

@property(nonatomic , assign) BOOL needRefreshPage;

@end

@implementation QLXPageView



-(void)reloadData{
    self.dataList = nil;   // 重新 获取咯
    [self.collectionView reloadData];
}


-(void)reloadDataWithPageIndex:(NSInteger)index{
    if (self.curPage == index) {
        [self reloadData];
    }
}

-(QLXCollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        _collectionView = [QLXCollectionView createWithFlowLayout];
        _collectionView.dataSourceDelegate = self;
        _collectionView.delegate = self;
        _collectionView.refreshEnable = false;
        _collectionView.pagingEnabled = true;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.allowsMultipleSelection = false;
        [_collectionView setBounces:false];
        [((UICollectionViewFlowLayout *)_collectionView.layout) setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        [self addSubview:_collectionView];
        [_collectionView constraintWithEdgeZero];
    }
    return _collectionView;
}

#pragma mark - QLXCollectionViewDataSourceDelegate
-(NSMutableArray *)cellDataListWithCollectionView:(QLXCollectionView *)collectionView{
    return self.dataList;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.pageViewDelegate respondsToSelector:@selector(pageView:didSelectPageAtIndex:)]) {
        [self.pageViewDelegate pageView:self didSelectPageAtIndex:indexPath.row];
    }
}


-(NSMutableArray *)dataList{
    if (!_dataList) {
        if ([self.pageViewDelegate respondsToSelector:@selector(pageDataListWithPageView:)]) {
            NSMutableArray * list = [self.pageViewDelegate pageDataListWithPageView:self];
            _dataList = [NSMutableArray new];
            for (NSObject * data in list) {
                id newData = data;
                if (![data isKindOfClass:[ReuseDataBase class]]) {
                    newData = [self createPageCellDataWithDataItem:data];
                }else {
                    ReuseDataBase * base = (ReuseDataBase *)newData;
                    base.height = self.height;
                    base.width = self.width;
                }
                [_dataList addObject:newData];
            }
        }
    }
    return _dataList;
}

-(QLXStaticPageCellData *)  createPageCellDataWithDataItem:(NSObject *)item{
    QLXStaticPageCellData * rData = [QLXStaticPageCellData new];
    rData.height = self.height;
    rData.width = self.width;
    if ([item isKindOfClass:[UIView class]]) {
        rData.singlePageView = (UIView *)item;
    }else if([item isKindOfClass:[UIViewController class]]){
        rData.controller = (UIViewController *)item;
    }else {
        assert(0);// 数据类型不对
    }
    return rData;
}



-(void)setCurPage:(NSInteger)curPage{
    [self setCurPage:curPage animated:false];
}


-(void)setCurPage:(NSInteger)curPage animated:(BOOL) animated{
    
    if (_curPage != curPage ) {
        _curPage = curPage;
        if ( [self.pageViewDelegate respondsToSelector:@selector(pageView:pageChanged:)]) {
            [self.pageViewDelegate pageView:self pageChanged:curPage];
        }
    }
    if (CGSizeEqualToSize(self.collectionView.contentSize, CGSizeZero)) {
        kBlockWeakSelf;
        [self.collectionView performInNextLoopWithBlock:^{
            weakSelf.collectionView.offsetX = weakSelf.curPage * weakSelf.width;
        }];
    }else {
        if (_curPage >= 0 && _curPage < self.dataList.count) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_curPage inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:animated];
        }
    }
    
}
-(void)setAdEnable:(BOOL)adEnable{
    self.collectionView.adEnable = adEnable;
}

-(BOOL)tracking{
    return self.collectionView.isTracking;
}

-(BOOL)decelerating{
    return self.collectionView.isDecelerating;
}

-(void)setPageViewDelegate:(id<QLXPageViewDelegate>)pageViewDelegate{
    _pageViewDelegate = pageViewDelegate;
    self.collectionView.cellDelegate = pageViewDelegate;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.pageViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.pageViewDelegate scrollViewDidScroll:scrollView];
    }
    {
        if (self.width > 0 ) {
            CGFloat curX = self.collectionView.contentOffset.x;
            NSInteger fromPage = self.curPage;//(int)(curX / self.width );
            CGFloat pageX = fromPage * self.width;
            CGFloat progress = (curX - pageX) / self.width;
            
            if (progress != -1 && progress != 1 ) {
                fromPage += (int)(progress);
                progress = progress - ((int)(progress));
            }
            
            if ([self.pageViewDelegate respondsToSelector:@selector(pageView:scrollPageProgress:fromPage:)]) {
                [self.pageViewDelegate pageView:self scrollPageProgress:progress fromPage:fromPage];
            }
            if ([self.pageViewDelegate respondsToSelector:@selector(pageView:scrollProgress:)]) {
                CGFloat scrollWith = self.collectionView.contentSize.width - self.width;
                
                CGFloat progress = 0;
                if (scrollWith) {
                    progress = curX / scrollWith;
                }
                [self.pageViewDelegate pageView:self scrollProgress:progress];
            }
        }
        
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.pageViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.pageViewDelegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.pageViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.pageViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.pageViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.pageViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.pageViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.pageViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([self.pageViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.pageViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.pageViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.pageViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
    {
        [self sendPageChangedDelegateIfNeed];
    }
}

-(void) sendPageChangedDelegateIfNeed{
    CGFloat curX = self.collectionView.contentOffset.x;
    NSInteger newPage = (int)(curX / self.width + 0.5);
    if (newPage != self.curPage) {
        [self setCurPage:newPage animated:false];
        if ([self.pageViewDelegate respondsToSelector:@selector(pageView:pageChanged:)]) {
            [self.pageViewDelegate pageView:self pageChanged:newPage];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([self.pageViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.pageViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
    {
        [self sendPageChangedDelegateIfNeed];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if ([self.pageViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        [self.pageViewDelegate viewForZoomingInScrollView:scrollView];
    }
    return nil;
}// return a view that will be scaled. if delegate returns nil, nothing happens
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    if ([self.pageViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.pageViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}// called before the scroll view begins zooming its content
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if ([self.pageViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.pageViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if ([self.pageViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        [self.pageViewDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return true;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if ([self.pageViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.pageViewDelegate scrollViewDidScrollToTop:scrollView];
    }
}




@end
