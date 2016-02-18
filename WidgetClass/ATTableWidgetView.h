//
//  ATTableWidgetView.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/28.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATWidgetBase.h"
@class ATWidgetBase;
@interface ATTableWidgetView : UIView

@property (nonatomic, strong) QLXTableView * tableView;
@property (nonatomic, strong) NSMutableArray * widgets;


/**
 *  添加一个部件
 *
 *  @param widget
 *  @param animated 是否有动画
 */
-(void) addWidget:(ATWidgetBase *) widget animated:(BOOL) animated;
/**
 *  删除一个部件
 *
 *  @param widget
 *  @param animated
 */
-(void) removeWidget:(ATWidgetBase *) widget animated:(BOOL) animated;

/**
 *  插入一个部件
 *
 *  @param widget
 *  @param section
 *  @param animated
 */
-(void) insertWidget:(ATWidgetBase *) widget section:(NSUInteger)section animated:(BOOL) animated;


/**
 *  判断是否已经有该类部件
 *
 *  @param aClass
 *
 *  @return
 */
-(BOOL) containWithWidgetClass:(Class) aClass;

// 子零件 刷新完成回调
-(void) requestRefreshFinish;


@end
