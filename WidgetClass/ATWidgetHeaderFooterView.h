//
//  ATWidgetHeaderFooterView.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/27.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXTableViewHeaderFooterView.h"

@interface ATWidgetHeaderFooterView : QLXTableViewHeaderFooterView

/**
 *  用这个构造 切记
 */
+(instancetype) create;
/**
 *  顾名思义 重写时记得调用[super createUI];
 *  UI在这里写
 */
-(void) createUI;

/**
 *  返回view 的 高度
 */
-(CGFloat) viewHeight;
/**
 *  刷新     [tableview reloadData] 时候回调
 */
-(void)refresh;

@end
