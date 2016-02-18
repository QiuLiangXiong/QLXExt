//
//  QLXTableViewPage.m
//  QLXExtDemo
//
//  Created by QLX on 15/10/31.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXTableViewPage.h"
#import "TablePageDataBase.h"
#import "QLXExt.h"

@interface QLXTableViewPage()

@property(nonatomic , assign) BOOL reloading;         // tableview realodData 中
@property(nonatomic , assign) BOOL deleratingEnable;  // 能否滚动
@property(nonatomic , assign) BOOL prepare;     // 是否还在复用队列
@property(nonatomic , assign) BOOL requesting;  // 请求中
@property(nonatomic , assign) BOOL reloadEnagle;

@end

@implementation QLXTableViewPage

-(void)createUI{
    [super createUI];
    [self.tableView constraintWithEdgeZero];
    
    
}



-(void)onEnter{
    [super onEnter];
    
    
    //  [self.tableView layoutIfNeeded];
    // NSLog(@"%.2lf",self.tableView.width);
}





-(void)reuseWithData:(ReuseDataBase *)data indexPath:(NSIndexPath *)indexPath{
    [super reuseWithData:data indexPath:indexPath];
    if (self.data.width ) {
        TablePageDataBase * rData =  (TablePageDataBase *)self.data;
        assert([rData isKindOfClass:[TablePageDataBase class]]);
        self.prepare = false;
        self.reloading = true;
        if (self.tableView.width == 0) {
            [self.tableView layoutIfNeeded];
        }
        [self.tableView reloadData];
        [self.tableView.refreshHeader endRefreshingWithResult:(QLXRefreshResultSuccess)];
        [self.tableView.refreshFooter endRefreshingWithResult:[self getResultWithState:rData.state]];
        self.reloading = false;
        
        self.deleratingEnable = false;
        self.tableView.offsetY =  rData.offsetY;
        if (self.collectionView.isDragging == false && !self.requesting) {
            [self.tableView excuteFadeInAnimation];
        }
        self.requesting = false;
    }
}

-(void)prepareForReuse{
    [super prepareForReuse];
    NSInteger page =  self.collectionView.curPage;
    if (self.indexPath.row != page) {     // 不是同一页面 就结束刷新
        [self.tableView.refreshHeader endRefreshingWithResult:QLXRefreshResultFail animated:false];
        if (self.requesting) {
            [self sendCancelLoadDelegate];
        }
        self.requesting = false;
        self.prepare = true;
        self.deleratingEnable = false;
    }
}

-(QLXRefreshResult)getResultWithState:(NSInteger)state{
    switch (state) {
        case 0:
            return QLXRefreshResultSuccess;
            break;
        case 1:
            return QLXRefreshResultNoMoreData;
            break;
        case -1:
            return QLXRefreshResultFail;
            break;
        default:
            return QLXRefreshResultSuccess;
            break;
    }
    return QLXRefreshResultSuccess;
}

#pragma mark - QLXTableViewDataSourceDelegate

-(NSMutableArray *)cellDataListWithTableView:(QLXTableView *)tableView{
    return ((TablePageDataBase * )self.data).cellDataList;
}

-(NSMutableArray *)headerDataListWithTableView:(QLXTableView *)tableView{
    return ((TablePageDataBase * )self.data).headerDataList;
}

-(NSMutableArray *)footerDataListWithTableView:(QLXTableView *)tableView{
    return ((TablePageDataBase * )self.data).footerDataList;
}


//下拉刷新
- (void)refreshTableViewDropRefresh:(UITableView *)refreshTableViewDropRefresh{
    if ([self.delegate respondsToSelector:@selector(page:reloadWithIndex:)]) {
        self.requesting = true;
        [((id<QLXTableViewPageDelegate>)self.delegate) page:self reloadWithIndex:self.indexPath.row];
    }
}
//上拉刷新
- (void)refreshTableViewUpRefresh:(UITableView *)refreshTableViewUpRefresh{
    if ([self.delegate respondsToSelector:@selector(page:loadMoreWithIndex:)]) {
        self.requesting = true;
        [((id<QLXTableViewPageDelegate>)self.delegate) page:self loadMoreWithIndex:self.indexPath.row];
    }
}

-(void) sendCancelLoadDelegate{
    if ([self.delegate respondsToSelector:@selector(page:cancelLoadWithIndex:)]) {
        [((id<QLXTableViewPageDelegate>)self.delegate) page:self cancelLoadWithIndex:self.indexPath.row];
    }
}

-(QLXTableView *)tableView{
    if (!_tableView) {
        _tableView = [QLXTableView createWithStyle:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.dataSourceDelegate = self;
        _tableView.tableViewDelegate = self;
        
    }
    return _tableView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.reloading == false) {
        TablePageDataBase * rData =  (TablePageDataBase *)self.data;
        
        CGFloat maxOffsetY = scrollView.contentH  - scrollView.height;
        if (maxOffsetY < 0) {
            maxOffsetY = 0;
        }
        rData.offsetY = fmin(maxOffsetY, fmax(0, scrollView.offsetY));
        if (!self.deleratingEnable) // 禁止惯性滚动
        {
            [scrollView setContentOffset:scrollView.contentOffset animated:NO];
        }
        if ([self.tableView.refreshHeader isRefreshing] && scrollView.offsetY > 0) {
            [self.tableView.refreshHeader endRefreshingWithResult:(QLXRefreshResultFail) animated:false];
            [self sendCancelLoadDelegate];
            //
        }
    }
    
}

-(void)setDelegate:(id<QLXCollectionViewCellDelegate>)delegate{
    [super setDelegate:delegate];
    self.tableView.cellDelegate = (id<QLXTableviewCellDelegate>)delegate;
    self.tableView.headerDelegate = (id<QlXTableViewHeaderFooterViewDelegate>)delegate;
    self.tableView.footerDelegate = (id<QlXTableViewHeaderFooterViewDelegate>)delegate;
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!self.prepare ) {
        self.deleratingEnable = true;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if ([self.delegate respondsToSelector:@selector(page:didSelectedWithCell:)]) {
        QLXTableViewCell * cell = (QLXTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [((id<QLXTableViewPageDelegate>)self.delegate) page:self didSelectedWithCell:cell];
    }
}



@end
