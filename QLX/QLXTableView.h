//
//  QLXTableView.h
//
//
//  Created by 邱良雄 on 15/8/8.
//  Copyright (c) 2015年 邱良雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXTableViewCell.h"
#import "QLXTableViewHeaderFooterView.h"
//#import "RefreshTableView.h"
#import "QLXRefreshBaseView.h"
#import "QLXRefreshHeaderView.h"
#import "QLXRefreshFooterView.h"
@protocol QLXTableViewDataSourceDelegate;
@protocol QLXTableViewDelegate;

@interface QLXTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic , weak)   id<QLXTableViewDataSourceDelegate> dataSourceDelegate;
@property(nonatomic , weak)   id<QLXTableViewDelegate> tableViewDelegate;
@property(nonatomic , weak)   id<QLXTableviewCellDelegate> cellDelegate;
@property(nonatomic , weak)   id<QlXTableViewHeaderFooterViewDelegate> headerDelegate;
@property(nonatomic , weak)   id<QlXTableViewHeaderFooterViewDelegate> footerDelegate;
@property(nonatomic , assign) BOOL refreshEnable;                   // 是否支持刷新
@property(nonatomic , assign,getter=isAnimating) BOOL animating;    // 是否在执行动画
@property(nonatomic , assign) BOOL adEnable;     // 是否支持广告轮播
@property(nonatomic , assign) CGFloat preRefreshDistance; // 提前刷新距离
@property (nonatomic, assign) BOOL firstReloadWithHorizeAnimationEnable;// 首次加载 水平过渡动画进入
@property (nonatomic, assign) BOOL firstReloadWithVerticalAnimationEnable; // 首次加载 竖直动画进入

/**
 *  注册类
 *
 *  @param cellClass 对类cell类名
 */
- (void)registerCellClass:(Class)cellClass ;

- (void)registerHeaderClass:(Class)aClass ;

- (void)registerFooterClass:(Class)aClass ;

+(QLXTableView *) createWithStyle:(UITableViewStyle) style;


-(void) endRefreshWithResult:(QLXRefreshResult) result;

-(void) beginRefresh;

-(void) beginRefreshHeader;

-(void) beginRefreshFooter;

-(void) requestFailure;

-(void) requestSuccess;

-(void) requestNoMoreData;
/**
 *  如果不想使用默认的刷新控件  可以使用这个添加
 *
 *  @param footer
 */
-(void) addRefreshFooter:(QLXRefreshFooterView *)footer;

-(void) addRefreshHeader:(QLXRefreshHeaderView *)header;

/**
 *  重新加载 伴随动画 如果cell行高变了 会有动画  一般用于单行cell高度的更新
 */
-(void) reloadDataWithAnimation;

/**
 *  重新加载 伴随动画 水平渐入
 */
-(void) reloadDataWithHorizontalOneByOneAnimation;
/**
 *  重新加载 伴随动画 竖直渐入
 */
-(void) reloadDataWithVerticalOneByOneAnimation;
/**
 *  一般用于两个数据不一致较大的reload（内容和行高都不一样时）  为了更好的过度界面  要用这个方法 ()
 *
 */
-(void)excuteFadeInAnimation;

@end



@protocol QLXTableViewDataSourceDelegate <NSObject>

@optional
/**
 * 数据源
 * 如果是静态表格 请返回UITableViewCell数组
 * 否则 返回 ReuseDataBase 派生类组成的数据 数组
 */
-(NSMutableArray *) cellDataListWithTableView:(QLXTableView *) tableView;
/**
 *  如果是静态表格 请返回UIHeaderFooterView数组
 *
 *  @param NSMutableArray
 *
 *  @return
 */
-(NSMutableArray *) headerDataListWithTableView:(QLXTableView *) tableView;
/**
 *  如果是静态表格 请返回UIHeaderFooterView数组
 *
 *  @return
 */
-(NSMutableArray *) footerDataListWithTableView:(QLXTableView *) tableView;



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

// Index

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;



@end


@protocol QLXTableViewDelegate <UITableViewDelegate>

@optional

//下拉刷新
- (void)refreshTableViewDropRefresh:(UITableView *)refreshTableViewDropRefresh success:(void (^)(BOOL result))success;

//上拉刷新
- (void)refreshTableViewUpRefresh:(UITableView *)refreshTableViewUpRefresh success:(void (^)(BOOL result))success;

//下拉刷新
- (void)refreshTableViewDropRefresh:(UITableView *)refreshTableViewDropRefresh;

//上拉刷新
- (void)refreshTableViewUpRefresh:(UITableView *)refreshTableViewUpRefresh;

@end

