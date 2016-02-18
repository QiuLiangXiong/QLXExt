//
//  QLXTableViewController.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/21.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXTableViewController.h"
#import "QLXExt.h"
@interface QLXTableViewController ()

@property (nonatomic, assign) UITableViewStyle style;
@property (nonatomic, assign)BOOL firstLayout;

@end

@implementation QLXTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    
    // Do any additional setup after loading the view.
}


-(void) setUp{
    self.view.backgroundColor = [UIColor whiteColor];
    self.firstRefreshEnable = true;
    [self.tableView constraintWithEdgeZero];
    //self.tableView
    //[self performSelector:@selector(firstRefresh) withObject:nil afterDelay:0];
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
            [self.tableView beginRefresh];
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
    [self.model requestToLoad];
}

-(UITableViewStyle) tableViewStyle{
    return self.style;
}
//数据请求完毕后  处理必要的逻辑
-(BOOL) requestFinishLogicWithData:(id)data  error:(NSError *) error{
    return true;
}

-(void) tableViewDidShow{
    
}

-(void) tableViewDidHide{
    
}

#pragma mark - QLXTabeleDelegate

-(void)refreshTableViewUpRefresh:(UITableView *)refreshTableViewUpRefresh{
    [self.model requestToLoadMore];
}

-(void)refreshTableViewDropRefresh:(UITableView *)refreshTableViewDropRefresh{
    [self.model requestToLoad];
}

#pragma mark - QLXTableDatasourceDelegate

-(NSMutableArray *)cellDataListWithTableView:(QLXTableView *)tableView{
   return self.model.data;
}

#pragma mark - QLXHttpModelDelegate

-(void)requestDidFinishWithData:(id)data hasMore:(BOOL)more error:(NSError *)error{
    if ([self requestFinishLogicWithData:data error:error]) {
        if (error) {
            if (self.firstFefreshing && self.requestErrorView) {
                [self showRequestErrorView];
            }else {
                [self showMainView];
                [self.tableView requestFailure];
            }
        }else {
            if (self.firstFefreshing && [self dataIsNone:data] && self.noneDataView != nil) {
                [self showNoneDataView];
            }else {
                [self showMainView];
            }
            if (!more) {
                [self.tableView requestNoMoreData];
            }else {
               [self.tableView requestSuccess];    
            }
            
        }
    }
    self.firstFefreshing = false;
}

-(QLXTableView *)tableView{
    if (!_tableView) {
        _tableView = [QLXTableView createWithStyle:[self tableViewStyle]];
        [self.view addSubview:_tableView];
        _tableView.dataSourceDelegate = self;
        _tableView.preRefreshDistance = kScreenHeight * 0.5;  // 预加载
        _tableView.tableViewDelegate = self;
    }
    return _tableView;
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

-(QLXHttpModel *)model{
    if (!_model) {
        _model = [self getModel];
    }
    if (_model) {
       if (_model.delegate == nil) {
            _model.delegate = self;
       }
    }
    return _model;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
