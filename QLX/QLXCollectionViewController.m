//
//  QLXCollectionViewController.m
//  fcuhConsumer
//
//  Created by QLX on 16/1/22.
//  Copyright © 2016年 avatar. All rights reserved.
//

#import "QLXCollectionViewController.h"
#import "QLXExt.h"

@interface QLXCollectionViewController ()

@property (nonatomic, assign)BOOL firstLayout;

@end

@implementation QLXCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.firstRefreshEnable = true;
    [self.collectionView constraintWithEdgeZero];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.firstRefreshEnable) {
        [self firstRefresh];
        self.firstRefreshEnable = false;
    }
}




-(void) firstRefresh{
    self.firstFefreshing = true;
    if (self.firstLoadingView == nil) {
        [self showMainView];
        [self.collectionView beginRefresh];
    }else {
        [self showFirstLoadingView];
        [self performSelector:@selector(delayFirstLoad) withObject:nil afterDelay:0.5];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) delayFirstLoad{
    [self.aModel requestToLoad];
}

//数据请求完毕后  处理必要的逻辑
-(BOOL) requestFinishLogicWithData:(id)data  error:(NSError *) error{
    return true;
}



#pragma mark - QLXCollectionViewDelegate

-(void)refreshCollectionViewUpRefresh:(QLXCollectionView *)collectionView{
     [self.aModel requestToLoadMore];
}

-(void)refreshCollectionViewDropRefresh:(QLXCollectionView *)collectionView{
    [self.aModel requestToLoad];
}


#pragma mark - QLXCollectionViewDatasourceDelegate

-(NSMutableArray *)cellDataListWithCollectionView:(QLXCollectionView *)collectionView{
    return self.aModel.data;
}


#pragma mark - QLXHttpModelDelegate

-(void)model:(QLXHttpModel *)model requestDidFinishWithData:(id)data hasMore:(BOOL)more error:(NSError *)error{
    if (model == self.aModel && [self requestFinishLogicWithData:data error:error]) {
        if (error) {
            if (self.firstFefreshing && self.requestErrorView) {
                [self showRequestErrorView];
            }else {
                [self showMainView];
                [self.collectionView requestFailure];
            }
        }else {
            if (self.firstFefreshing && [self dataIsNone:data] && self.noneDataView != nil) {
                [self showNoneDataView];
            }else {
                [self showMainView];
            }
            if (!more) {
                [self.collectionView requestNoMoreData];
            }else {
                [self.collectionView requestSuccess];
            }
            
        }
    }
    self.firstFefreshing = false;
}



-(QLXCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [QLXCollectionView createWithLayout:[self getCollectionViewLayout]];
        [self.view addSubview:_collectionView];
        _collectionView.refreshEnable = true;
        _collectionView.dataSourceDelegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.preRefreshDistance = kScreenHeight * 0.5;  // 预加载
        _collectionView.collectionViewDelegate = self;
    }
    return _collectionView;
}

-(BOOL) dataIsNone:(id) data{
    if ([data isKindOfClass:[NSArray class]]) {
        return ((NSArray *)data).count == 0;
    }
    if ([data isKindOfClass:[NSMutableArray class]]) {
        return ((NSMutableArray *)data).count == 0;
    }
    return data == nil;
}


-(QLXHttpModel *) getModel{
    return nil;
}

-(QLXHttpModel *)aModel{
    if (!_aModel) {
        _aModel = [self getModel];
    }
    if (_aModel) {
        if (_aModel.delegate == nil) {
            _aModel.delegate = self;
        }
    }
    return _aModel;
}


-(UICollectionViewLayout *)getCollectionViewLayout{
    return [UICollectionViewFlowLayout new];
}



@end
