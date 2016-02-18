//
//  QLXTableViewCell.h
//
//
//  Created by 邱良雄 on 15/8/8.
//  Copyright (c) 2015年 邱良雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReuseDataBase.h"
@protocol QLXTableviewCellDelegate;
@class QLXTableView;
@interface QLXTableViewCell : UITableViewCell

@property(nonatomic , strong) ReuseDataBase * data;
@property(nonatomic , strong) NSIndexPath * indexPath;
@property(nonatomic , weak) id<QLXTableviewCellDelegate> delegate;
@property (nonatomic, strong) UIView * lineV;
@property (nonatomic, weak) QLXTableView * tableView;
@property (nonatomic, assign) BOOL highlightEnable;   // 能否有默认高亮状态  默认可高亮
@property (nonatomic, assign) BOOL selectEnable;   // 选中 默认不能选中状态
@property (nonatomic, strong) UIView * view; //cell内容容器 cell 的视图都要 [self.view addSubview:subview];
@property(nonatomic , assign) BOOL dynamicCellSize; // 是否为动态大小  默认为静态 如果不是要设置为true才行

-(void) createUI;

-(void) reuseWithData:(ReuseDataBase *) data indexPath:(NSIndexPath *) indexPath;

-(void) setSeparatorLineHidden;

-(void) setSeparatorLineShow;

-(CGFloat) cellHeight;

-(void) setSeparatorLineShowWithInset:(UIEdgeInsets ) edgeInset;

-(void) setSeparatorLineColor:(UIColor *) color;
/**
 *  刷新 可重新
 */
-(void) refresh;
@end

@protocol QLXTableviewCellDelegate <NSObject>

@optional

-(void) tableViewCell:(QLXTableViewCell *)cell didSelect:(NSIndexPath *)indexPath;
-(void) tableViewCell:(QLXTableViewCell *)cell didHighlited:(NSIndexPath *)indexPath;


@end
