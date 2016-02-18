//
//  ATWidgetHeaderFooterView.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/27.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "ATWidgetHeaderFooterView.h"

@implementation ATWidgetHeaderFooterView

+(instancetype)create{
    return [super create];
}
/**
 *  顾名思义 重写时记得调用[super createUI];
 */
-(void) createUI{
    [super createUI];
}

/**
 *  返回view 的 高度
 */
-(CGFloat) viewHeight{
    return [super viewHeight];
}
/**
 *  刷新     [tableview reloadData] 时候回调
 */
-(void)refresh{
    [super refresh];
}

@end
