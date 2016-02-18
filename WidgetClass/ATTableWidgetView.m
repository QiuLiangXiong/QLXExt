//
//  ATTableWidgetView.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/28.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "ATTableWidgetView.h"
#import "ATWidgetManager.h"
#import "QLXExt.h"

@interface ATTableWidgetView()<QLXTableViewDelegate , QLXTableViewDataSourceDelegate >

@property (nonatomic, strong) NSMutableArray * widgetDataList;
@property (nonatomic, strong) NSMutableArray * widgetHeaderDataList;
@property (nonatomic, strong) NSMutableArray * widgetFooterDataList;

@end

@implementation ATTableWidgetView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initConfigs];
    }
    return self;
}

-(void) initConfigs{
    [self.tableView constraintWithEdgeZero];
}

-(QLXTableView *)tableView{
    if (!_tableView) {
        _tableView = [QLXTableView createWithStyle:UITableViewStyleGrouped];
        [self addSubview:_tableView];
        _tableView.dataSourceDelegate = self;
        _tableView.tableViewDelegate = self;
        [_tableView removeRefreshFooter];
    }
    return _tableView;
}

-(void)onEnter{
    [super onEnter];
    [[ATWidgetManager getInstance] registerTableWidgetViewWithController:[self viewController] tableWidgeView:self];
}



// 添加部件

-(void) addWidget:(ATWidgetBase *) widget animated:(BOOL) animated{
    assert(widget);
    NSUInteger section = self.widgetHeaderDataList.count;
    [self insertWidget:widget section:section animated:animated];
}

// 插入部件
-(void) insertWidget:(ATWidgetBase *) widget section:(NSUInteger)section animated:(BOOL) animated{
    
    
    if ([self containWithWidget:widget] == false) {
        widget.tableWidgetView = self;
        [self.widgetHeaderDataList insertObject:widget.widgetHeaderView atIndex:section];
        [self.widgetFooterDataList insertObject:widget.widgetFooterView atIndex:section];
        if (widget.dataList) {
            [self.tableView registerCellClass:[widget class]];
            [self.widgetDataList insertObject:widget.dataList atIndex:section];
        }else {
            NSMutableArray * array = [[NSMutableArray alloc] initWithObjects:widget, nil];
            [self.widgetDataList insertObject:array atIndex:section];
        }
        [self.widgets addObject:widget];
        /**
         *  加入动画动画
         */
        if (animated) {
            [self.tableView beginUpdates];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationNone)];
            [self.tableView endUpdates];
        }else {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refresh) object:nil];
            [self performSelector:@selector(refresh) withObject:nil afterDelay:0.01];
        }
        
    }
}

// 删除部件

-(void) removeWidget:(ATWidgetBase *) widget animated:(BOOL) animated{
    NSUInteger section = [self.widgetHeaderDataList indexOfObject:widget.widgetHeaderView];
    [self.widgetHeaderDataList removeObject:widget.widgetHeaderView];
    [self.widgetFooterDataList removeObject:widget.widgetFooterView];
    
    if (widget.dataList) {
        [self.widgetDataList removeObject:widget.dataList];
    }else {
        [self.widgetDataList removeObjectAtIndex:section];
    }
    [self.widgets removeObject:widget];
    [widget removeFromSuperview];
    while ([self.tableView dequeueReusableCellWithIdentifier:[widget className]]) {
        
    }
    /**
     *  删除动画
     */
    if (animated) {
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationFade)];
        [self.tableView endUpdates];
    }else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refresh) object:nil];
        [self performSelector:@selector(refresh) withObject:nil afterDelay:0.01];
    }
}

-(BOOL) containWithWidget:(ATWidgetBase *)widget{
    return [self containWithWidgetClass:[widget class]];
}

-(BOOL) containWithWidgetClass:(Class) aClass{
    for (ATWidgetBase * sub in self.widgets) {
        if ([sub isMemberOfClass:aClass]) {
            return true;
        }
    }
    return false;
}

-(void) refresh{
    [self.tableView reloadData];
}

-(NSMutableArray *)widgetHeaderDataList{
    if (!_widgetHeaderDataList) {
        _widgetHeaderDataList = [NSMutableArray new];
    }
    return _widgetHeaderDataList;
}

-(NSMutableArray *)widgetFooterDataList{
    if (!_widgetFooterDataList) {
        _widgetFooterDataList = [NSMutableArray new];
    }
    return _widgetFooterDataList;
}

-(NSMutableArray *)widgetDataList{
    if (!_widgetDataList) {
        _widgetDataList = [NSMutableArray new];
    }
    return _widgetDataList;
}

-(NSMutableArray *)widgets{
    if (!_widgets) {
        _widgets = [NSMutableArray new];
    }
    return _widgets;
}



#pragma mark - QLXTableViewDataSourceDelegate


-(NSMutableArray *)cellDataListWithTableView:(QLXTableView *)tableView{
    return self.widgetDataList;
}

-(NSMutableArray *)headerDataListWithTableView:(QLXTableView *)tableView{
    return self.widgetHeaderDataList;
}

-(NSMutableArray *)footerDataListWithTableView:(QLXTableView *)tableView{
    return self.widgetFooterDataList;
}

// 单例固定模板
+(instancetype) getInstance{
    static id instance;
    GCDExecOnce(^{
        if (instance == nil) {
            instance = [self new];
        }
    });
    return instance;
}

/**
 *  上啦刷新时
 *
 *  @param refreshTableViewUpRefresh <#refreshTableViewUpRefresh description#>
 */
-(void)refreshTableViewUpRefresh:(UITableView *)refreshTableViewUpRefresh{
    for (ATWidgetBase * widget in self.widgets) {
        widget.needRequst = true;
        [widget requestUpRefresh];
    }
}

/**
 *  下拉刷新时
 *
 *  @param refreshTableViewDropRefresh
 */
-(void)refreshTableViewDropRefresh:(UITableView *)refreshTableViewDropRefresh{
    for (ATWidgetBase * widget in self.widgets) {
        widget.needRequst = true;
        [widget requestDropRefresh];
    }
}

-(void) requestRefreshFinish{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(requestFinishIfNeed) withObject:nil afterDelay:0.01];
    
    
}

-(void) requestFinishIfNeed{
    BOOL finish = true;
    for (ATWidgetBase * widget in self.widgets) {
        if (widget.needRequst) {
            finish = false;
            break;
        }
    }
    if ( finish ) {
        [self.tableView endRefreshWithResult:(QLXRefreshResultSuccess)];
    }
}


@end
