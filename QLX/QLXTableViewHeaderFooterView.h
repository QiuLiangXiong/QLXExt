//
//  QLXTableViewHeaderFooterView.h
//
//
//  Created by 邱良雄 on 15/8/8.
//  Copyright (c) 2015年 邱良雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReuseDataBase.h"
@class QLXTableView;
@protocol QlXTableViewHeaderFooterViewDelegate;
@interface QLXTableViewHeaderFooterView : UITableViewHeaderFooterView
@property(nonatomic , strong) ReuseDataBase * data;
@property(nonatomic , assign) NSInteger section;
@property(nonatomic , assign) BOOL bHeader;
@property(nonatomic , weak) id<QlXTableViewHeaderFooterViewDelegate> delegate;
@property (nonatomic, weak) QLXTableView * tableView;
@property (nonatomic, strong) UIView * view; //cell内容容器 cell 的视图都要 [self.view addSubview:subview];
@property(nonatomic , assign) BOOL dynamicViewSize; // 是否为动态大小  默认为静态 如果不是要设置为true才行

+(instancetype) create;

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
/**
 *  顾名思义 重写时记得调用[super createUI];
 */
-(void) createUI;

-(void) reuseWithData:(ReuseDataBase *) data section:(NSInteger) section isHeader:(BOOL) bHeader;
/**
 *  返回view 的 高度
 */
-(CGFloat) viewHeight;
/**
 *  刷新     [tableview reloadData] 时候回调
 */
-(void)refresh;

@end

@protocol QlXTableViewHeaderFooterViewDelegate <NSObject>



@end