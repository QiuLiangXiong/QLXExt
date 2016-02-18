//
//  ATWidgetBase.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/27.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXTableViewCell.h"
#import "QLXExt.h"
#import "ATWidgetHeaderFooterView.h"
#import "ATWidgetManager.h"
#import "ATTableWidgetView.h"
@class ATTableWidgetView;
@interface ATWidgetBase : QLXTableViewCell


@property (nonatomic, strong) ATWidgetHeaderFooterView * widgetHeaderView; // 头部视图
@property (nonatomic, strong) ATWidgetHeaderFooterView * widgetFooterView; // 尾部视图
@property (nonatomic, strong) NSMutableArray * dataList; // 数据类型务必是 ReuseDataBase  self 对应的数据项
@property (nonatomic, weak)   ATTableWidgetView * tableWidgetView;   // 容器
@property (nonatomic, assign) BOOL needRequst;  // 需要刷新标记

/**
 *  实例化一个对象
 */
+(instancetype) create;

/**
 * 继承哦
 *  self.view 去添加子视图
 */
-(void) viewDidLoad;

/**
 *  需要重写
 *
 *  @return self 的高度
 */
-(CGFloat) viewHeight;

/**
 *   optional to overriding
 *   重写时 不要 调用父类该方法
 *   上拉刷新
 */
-(void) requestUpRefresh;

/**
 *  下拉刷新
*   重写时 不要 调用父类该方法
 */
-(void) requestDropRefresh;

/**
 *  请求数据完毕时回调
 */
-(void)requestFinish;

/**
 *  当tableview reload 的 时候 回调
 */
-(void) refresh;
/**
 *  当我们数据更新或请求完成时  有需要的话  可以主动调用这个方法 刷新自己
 */
-(void) reloadData;

/**
 *  tableview 根据 datalist 的数据 来 配置相应的view
 *
 *  @param data  来自dataList 中的一个数据
 *  @param indexPath   在数组中的位置
 */
-(void)reuseWithData:(ReuseDataBase *)data indexPath:(NSIndexPath *)indexPath;

/**
 *  删除自己这个部件
 *
 *  @param animated
 */
-(void)removeFromWidgetControllerWithAnimated:(BOOL) animated;


/**
 *  添加部件到 控制器
 *
 *  @param aClass
 *  @param secion 在 部件数组的所占位置
 *  @return  添加成功 或者失败  
 */
+(BOOL) addWidgetWithControllerClass:(Class) aClass section:(NSUInteger)secion;

@end
