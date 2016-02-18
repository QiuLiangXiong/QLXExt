//
//  ATWidgetBase.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/27.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "ATWidgetBase.h"
#import "QLXExt.h"

@interface ATWidgetBase()



@end

@implementation ATWidgetBase

+(instancetype)create{
    return [[self alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:[self className]];
}

-(void)createUI{
    [super createUI];
    [self viewDidLoad];
}

-(void)viewDidLoad{
    self.selectEnable = false;
    [self setHighlightEnable:false];
    // 一样的配方 一样的味道
    // self.view 去添加子视图
}

-(CGFloat)viewHeight{
    return 0;
}

-(CGFloat)cellHeight{
    if ([self viewHeight] != 0) {
        return [self viewHeight];
    }
    return [super cellHeight];
}

/**
 *   optional to overriding
 *   上拉刷新
 */
-(void) requestUpRefresh{
    [self requestFinish];
}

/**
 *  下拉刷新
 */
-(void) requestDropRefresh{
    [self requestFinish];
}

-(void) requestFinish{
    self.needRequst = false;
    [self.tableWidgetView requestRefreshFinish];
}

-(void) refresh{
    [super refresh];
}

-(void) reloadData{
    [self.tableView reloadData];
}

-(void)reuseWithData:(ReuseDataBase *)data indexPath:(NSIndexPath *)indexPath{
    [super reuseWithData:data indexPath:indexPath];
}

-(ATWidgetHeaderFooterView *)widgetHeaderView{
    if (!_widgetHeaderView) {
        _widgetHeaderView = [ATWidgetHeaderFooterView new];
    }
    return _widgetHeaderView;
}

-(ATWidgetHeaderFooterView *)widgetFooterView{
    if (!_widgetFooterView) {
        _widgetFooterView = [ATWidgetHeaderFooterView new];
    }
    return _widgetFooterView;
}

-(void)removeFromWidgetControllerWithAnimated:(BOOL) animated{
    [self.tableWidgetView removeWidget:self animated:animated];
}

+(BOOL) addWidgetWithControllerClass:(Class) aClass section:(NSUInteger)secion{
    ATTableWidgetView * table = [[ATWidgetManager getInstance] getTableWidgetViewWithControllerClass:aClass];
    if (table) {
        if ([table containWithWidgetClass:[self class]] == false) {
            [table insertWidget:[self create] section:secion animated:true];
            return true;
        }
    }
    return false;
}

@end
