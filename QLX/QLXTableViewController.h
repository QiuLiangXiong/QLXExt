//
//  QLXTableViewController.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/21.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXTableView.h"
#import "QLXHttpModel.h"
#import "QLXViewController.h"
#import "QLXHttpController.h"

@interface QLXTableViewController : QLXHttpController<QLXTableViewDelegate , QLXTableViewDataSourceDelegate ,QLXHttpModelDelegate>
@property (nonatomic, assign) BOOL firstRefreshEnable;  //是否允许第一次刷新
@property (nonatomic, assign) BOOL firstFefreshing;
@property (nonatomic, strong) QLXTableView * tableView;
@property (nonatomic, strong) QLXHttpModel * model;

//- (instancetype)initWithStyle:(UITableViewStyle)style ;
/**
 *  初始化 可以继承
 */
-(void) setUp;
/**
 *  首次刷新 可以重复调用
 */
-(void) firstRefresh;

// tableview 风格
-(UITableViewStyle) tableViewStyle;

//数据请求完毕后  处理必要的逻辑
-(BOOL) requestFinishLogicWithData:(id)data  error:(NSError *) error;



-(QLXHttpModel *) getModel;


@end
