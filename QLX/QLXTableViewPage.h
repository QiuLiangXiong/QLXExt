//
//  QLXTableViewPage.h
//  QLXExtDemo
//
//  Created by QLX on 15/10/31.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXPageViewCell.h"
#import "QLXTableView.h"
#import "QLXRefreshBaseView.h"

@interface QLXTableViewPage : QLXPageViewCell<QLXTableViewDelegate , QLXTableViewDataSourceDelegate>

@property (nonatomic, strong) QLXTableView * tableView;

// 可以重写这个根据状态值来 返回 tableview 刷新状态
-(QLXRefreshResult) getResultWithState:(NSInteger)state;

@end



@protocol QLXTableViewPageDelegate <QLXPageViewCellDelegate >
@optional

// 刷新数据 index  代表第几页
-(void) page:(QLXTableViewPage *)page reloadWithIndex:(NSInteger)index;
// 加载更多数据
-(void) page:(QLXTableViewPage *)page loadMoreWithIndex:(NSInteger)index;
// 取消加载
-(void) page:(QLXTableViewPage *)page cancelLoadWithIndex:(NSInteger)index;

// 选中这个taleviewPage 的中 的某一行  cell 中有data  和 indexPath属性 给你具体信息
-(void) page:(QLXTableViewPage *)page didSelectedWithCell:(QLXTableViewCell *)cell ;
@end
