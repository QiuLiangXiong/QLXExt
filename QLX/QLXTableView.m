//
//  QLXTableView.m
//
//
//  Created by QLX on 15/8/8.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import "QLXTableView.h"
#import "QLXExt.h"
@interface QLXTableView()
@property(nonatomic , copy)   NSString * cellReuseIdentifier;
@property(nonatomic , copy)   NSString * headerViewReuseIdentifier;
@property(nonatomic , copy)   NSString * footerViewReuseIdentifier;
@property(nonatomic , strong) NSMutableDictionary * cacheCellDic;
@property(nonatomic , strong) NSMutableDictionary * cacheHeaderViewDic;
@property(nonatomic , strong) NSMutableDictionary * cacheFooterViewDic;
@property(nonatomic , assign)  NSInteger animationCount;
@property(nonatomic , strong) UITapGestureRecognizer * scrollTopTapGes;

@end

@implementation QLXTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initConfigs];
    }
    return self;
}
/**
 *  初始化
 */
-(void) initConfigs{
    self.dataSource = self;
    self.delaysContentTouches = false;
    self.delegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshEnable = true;
}

-(void)setRefreshEnable:(BOOL)refreshEnable{
    if (_refreshEnable != refreshEnable) {
        _refreshEnable = refreshEnable;
        if (refreshEnable) {
            [self addRefreshHeaderWithTarget:self refreshingAction:@selector(headerRefresh)];
            [self addRefreshFooterWithTarget:self refreshingAction:@selector(footerRefresh)];
        }else {
            [self removeRefreshHeader];
            [self removeRefreshFooter];
        }
    }
}

-(void) addRefreshFooter:(QLXRefreshFooterView *)footer{
    [self addRefreshFooterWithTarget:self refreshingAction:@selector(footerRefresh) footer:footer];
}

-(void) addRefreshHeader:(QLXRefreshHeaderView *)header{
    [self addRefreshHeaderWithTarget:self refreshingAction:@selector(headerRefresh) header:header];
}

-(void) tapToScrollTop{
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:true];
}

-(void) headerRefresh{
    if (self.refreshFooter.resultState == QLXRefreshResultNoMoreData ) {
        [self.refreshFooter endRefreshingWithResult:QLXRefreshResultNoMoreData];
    }else {
        [self.refreshFooter endRefreshingWithResult:QLXRefreshResultSuccess];
    }
    //下拉刷新
    [self refreshTableViewDropRefresh:self];
}

-(void) footerRefresh{
    if([self.refreshHeader isRefreshing]){
        [self.refreshHeader endRefreshingWithResult:QLXRefreshResultFail];
    }
    [self refreshTableViewUpRefresh:self];
}

-(void) endRefreshWithResult:(QLXRefreshResult) result{
    [self reloadData];
    if (self.firstReloadWithVerticalAnimationEnable) {
        self.firstReloadWithVerticalAnimationEnable = false;
        [self startVerticalOneByOneAnimation];
    }
    if (self.firstReloadWithHorizeAnimationEnable) {
        self.firstReloadWithHorizeAnimationEnable = false;
        [self startHorizontalOneByOneAnimation];
    }
    [self.refreshFooter endRefreshingWithResult:result];
    if([self.refreshHeader isRefreshing]){
        [self.refreshHeader endRefreshingWithResult:result];
    }
}

-(void) beginRefresh{
    [self.refreshFooter endRefreshingWithResult:QLXRefreshResultSuccess];
    [self headerBeginRefresh];
}

-(void) beginRefreshHeader{
    [self.refreshFooter endRefreshingWithResult:QLXRefreshResultSuccess];
    [self headerBeginRefresh];
}

-(void) beginRefreshFooter{
    if ([self.refreshHeader isRefreshing]) {
        [self.refreshHeader endRefreshingWithResult:QLXRefreshResultFail];
    }
    [self footerBeginRefresh];
}

-(void) requestFailure{
    [self endRefreshWithResult:QLXRefreshResultFail];
}

-(void) requestSuccess{
    [self endRefreshWithResult:QLXRefreshResultSuccess];
}

-(void) requestNoMoreData{
    [self endRefreshWithResult:QLXRefreshResultNoMoreData];
}

+(QLXTableView *) createWithStyle:(UITableViewStyle) style{
    return [[QLXTableView alloc] initWithFrame:CGRectZero style:style];
}

- (void)registerCellClass:(Class)cellClass{
    self.cellReuseIdentifier = NSStringFromClass(cellClass);
    [super registerClass:cellClass forCellReuseIdentifier:self.cellReuseIdentifier];
}

-(void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier{
    [self registerCellClass:cellClass];
}


- (void)registerHeaderClass:(Class)aClass {
    self.headerViewReuseIdentifier = NSStringFromClass(aClass);
    [super registerClass:aClass forHeaderFooterViewReuseIdentifier:self.headerViewReuseIdentifier];
}

-(void)registerClass:(Class)aClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier{
    if (self.headerViewReuseIdentifier) {
        [self registerFooterClass:aClass];
    }else {
        [self registerHeaderClass:aClass];
    }
    
}

- (void)registerFooterClass:(Class)aClass {
    self.footerViewReuseIdentifier = NSStringFromClass(aClass);
    [super registerClass:aClass forHeaderFooterViewReuseIdentifier:self.footerViewReuseIdentifier];
}



-(void)setDelegate:(id<UITableViewDelegate>)delegate{
    if (((id)(delegate)) != self) {
        self.tableViewDelegate = (id<QLXTableViewDelegate>)delegate;
    }else {
        [super setDelegate:delegate];
    }
}
-(NSMutableArray * )getSectionDataListWithIndexPath:(NSIndexPath *) indexPath{
    if ([self.dataSourceDelegate respondsToSelector:@selector(cellDataListWithTableView:)]) {
        NSMutableArray * list = [self.dataSourceDelegate cellDataListWithTableView:self];
        if (list.count > 0 && [[list firstObject] isKindOfClass:[NSArray class]]) {
            if (list.count > indexPath.section) {
                return [list objectAtIndex:indexPath.section];
            }else {
                assert(0);//(false, @"list.count <= section 数据越界");
            }
        }else {
            return list;
        }
    }else{
        assert(false);//未实现该cellDataList 协议
    }
    return nil;
}
#pragma mark - dataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataSourceDelegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [self.dataSourceDelegate tableView:tableView numberOfRowsInSection:section];
    }else{
        if ([self.dataSourceDelegate respondsToSelector:@selector(cellDataListWithTableView:)]) {
            NSArray * array = [self getSectionDataListWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            if (array == nil && array.count == 0) {
                return 0;
            }else {
                return array.count;
            }
            
        }
    }
    assert(false);//没有实现QLXTableViewDataSourceDelegate cellDataList 代理方法
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSourceDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [self.dataSourceDelegate tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return false;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSourceDelegate respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        return [self.dataSourceDelegate tableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    return false;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSourceDelegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [self.dataSourceDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
    }else {
        id data = [[self getSectionDataListWithIndexPath:indexPath] objectAtIndex:indexPath.row];
        if ([data isKindOfClass:[QLXTableViewCell class]]) {
            ((QLXTableViewCell *)data).tableView = self;
            [data reuseWithData:nil indexPath:indexPath];
            [data refresh];
          //  [data refreshLayout];
            return data;
        }
        
        ReuseDataBase * reuseData = (ReuseDataBase *)data;
        assert([ReuseDataBase isSubclassOfClass:[ReuseDataBase class]]);
        
        NSString * reuseIdentifier = [reuseData reuseIdentifier];
        if (reuseIdentifier == nil) {
            reuseIdentifier = self.cellReuseIdentifier;
        }
        QLXTableViewCell * cell = [self dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        assert(cell && [cell isKindOfClass:[QLXTableViewCell class]]); //没有继承QLXTableViewCell或没有注册
        cell.tableView = self;
        [cell reuseWithData:data indexPath:indexPath];
        [cell refreshLayout];
        cell.delegate = self.cellDelegate;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.dataSourceDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.dataSourceDelegate numberOfSectionsInTableView:tableView];
    }else if([self.dataSourceDelegate respondsToSelector:@selector(cellDataListWithTableView:)]){
        NSArray * list = [self.dataSourceDelegate cellDataListWithTableView:self];
        if (list.count > 0 && [[list firstObject] isKindOfClass:[NSArray class]]) {
            return list.count;
        }else if(list.count > 0){
            return 1;
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([self.dataSourceDelegate respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return [self.dataSourceDelegate tableView:tableView titleForHeaderInSection:section];
    }else {
        
    }
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if ([self.dataSourceDelegate respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        return [self.dataSourceDelegate tableView:tableView titleForFooterInSection:section];
    }else {
        
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if ([self.dataSourceDelegate respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        return [self.dataSourceDelegate sectionIndexTitlesForTableView:tableView];
    }else {
        
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if ([self.dataSourceDelegate respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        return [self.dataSourceDelegate tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }else {
        
    }
    return 0;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSourceDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.dataSourceDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }else {
        
    }
}



- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if ([self.dataSourceDelegate respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        [self.dataSourceDelegate tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }else {
        
    }
}


#pragma mark - tableview Delegate

// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.tableViewDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }else{
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [self.tableViewDelegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }else {
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]) {
        [self.tableViewDelegate tableView:tableView willDisplayFooterView:view forSection:section];
    }else {
        
    }
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [self.tableViewDelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }else {
        
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)]) {
        [self.tableViewDelegate tableView:tableView didEndDisplayingHeaderView:view forSection:section ];
    }else {
        
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]) {
        [self.tableViewDelegate tableView:tableView didEndDisplayingFooterView:view forSection:section ];
    }else {
        
    }
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath ];
    }else if([self.dataSourceDelegate respondsToSelector:@selector(cellDataListWithTableView:)] ){
        id data = [[self getSectionDataListWithIndexPath:indexPath] objectAtIndex:indexPath.row] ;
        if ([data isKindOfClass:[QLXTableViewCell class]]) {
            assert([data isKindOfClass:[QLXTableViewCell class]]);
            ((QLXTableViewCell *)data).tableView = self;
            [data reuseWithData:nil indexPath:indexPath];
            [data refresh];
            return [(QLXTableViewCell *)data cellHeight];
        }
        
        ReuseDataBase * reuseData = ((ReuseDataBase *)data);
        assert([data isKindOfClass:[ReuseDataBase class]]);//要继承ReuseDataBase
        
        QLXTableViewCell * cacheCell = [self getCacheCellWithReuseIdentifier:[reuseData reuseIdentifier]];
        if (reuseData.height == 0) {
            if (!cacheCell.dynamicCellSize && (cacheCell.data.height > 0)) {
                return  cacheCell.data.height;
            }
            
            [cacheCell reuseWithData:reuseData indexPath:indexPath];
            CGFloat height = [cacheCell cellHeight];
            reuseData.height = height;
        }
        return reuseData.height;
    }
    return 0.00;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.tableViewDelegate tableView:tableView heightForHeaderInSection:section ];
    }else {
        if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithTableView:)] && [self.dataSourceDelegate headerDataListWithTableView:self]){
            id data = [[self.dataSourceDelegate headerDataListWithTableView:self] objectAtIndex:section];
            if ([data isKindOfClass:[QLXTableViewHeaderFooterView class]]) {
                ((QLXTableViewHeaderFooterView *)data).tableView = self;
                [data reuseWithData:nil section:section isHeader:true];
                [data refresh];
                return [(QLXTableViewHeaderFooterView *)data viewHeight];
            }
            ReuseDataBase * reuseData = ((ReuseDataBase *)data);
            assert([data isKindOfClass:[ReuseDataBase class]]);//要继承ReuseDataBase
            
            QLXTableViewHeaderFooterView * cacheHeaderView = [self getCacheHeaderViewWithReuseIdentifier:[reuseData reuseIdentifier]];
            if(reuseData.height == 0) {
                if (!cacheHeaderView.dynamicViewSize && (cacheHeaderView.data.height > 0)) {
                    return  cacheHeaderView.data.height;
                }
                [cacheHeaderView reuseWithData:reuseData section:section isHeader:true];
                reuseData.height = [cacheHeaderView viewHeight];
            }
            return reuseData.height;
        }
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [self.tableViewDelegate tableView:tableView heightForFooterInSection:section ];
    }else {
        if ([self.dataSourceDelegate respondsToSelector:@selector(footerDataListWithTableView:)] && [self.dataSourceDelegate footerDataListWithTableView:self]){
            id data = [[self.dataSourceDelegate footerDataListWithTableView:self] objectAtIndex:section];
            if ([data isKindOfClass:[QLXTableViewHeaderFooterView class]]) {
                //data 必须 是 QLXTableViewHeaderFooterView 子类
                ((QLXTableViewHeaderFooterView *)data).tableView = self;
                [data reuseWithData:nil section:section isHeader:false];
                [data refresh];
                return [(QLXTableViewHeaderFooterView *)data viewHeight];
            }
            ReuseDataBase * reuseData = ((ReuseDataBase *)data);
            assert([data isKindOfClass:[ReuseDataBase class]]);//要继承ReuseDataBase
            
            QLXTableViewHeaderFooterView * cacheFooterView = [self getCacheFooterViewWithReuseIdentifier:[reuseData reuseIdentifier]];
            if(reuseData.height == 0) {
                if (!cacheFooterView.dynamicViewSize && (cacheFooterView.data.height > 0)) {
                    return  cacheFooterView.data.height;
                }
                [cacheFooterView reuseWithData:reuseData section:section isHeader:false];
                reuseData.height = [cacheFooterView viewHeight];
            }
            return reuseData.height;
        }
    }
    return 0.01;
}

// Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
//// If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0);
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0);
//
//// Section header & footer information. Views are preferred over title should you decide to provide both
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.tableViewDelegate tableView:tableView viewForHeaderInSection:section];
    }else {
        if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithTableView:)] && [self.dataSourceDelegate headerDataListWithTableView:self]){
            id data = [[self.dataSourceDelegate headerDataListWithTableView:self] objectAtIndex:section];
            if ([data isKindOfClass:[QLXTableViewHeaderFooterView class]]) {
                ((QLXTableViewHeaderFooterView *)data).tableView = self;
                [(QLXTableViewHeaderFooterView *)data reuseWithData:nil section:section isHeader:true];
                [(QLXTableViewHeaderFooterView *)data refresh];
                [(QLXTableViewHeaderFooterView *)data refreshLayout];
                return data;
            }
            ReuseDataBase * reuseData = (ReuseDataBase *)data;
            assert([ReuseDataBase isSubclassOfClass:[ReuseDataBase class]]);
            
            NSString * reuseIdentifier = [reuseData reuseIdentifier];
            if (reuseIdentifier == nil) {
                reuseIdentifier = self.headerViewReuseIdentifier;
            }
            QLXTableViewHeaderFooterView * view = [self dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
            assert(view && [view isKindOfClass:[QLXTableViewHeaderFooterView class]]);
            view.tableView = self;
            [view reuseWithData:reuseData section:section isHeader:true];
            view.delegate = self.headerDelegate;
            [view refreshLayout];
            return view;
        }
    }
    return nil;
}// custom view for header. will be adjusted to default or specified header height
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.tableViewDelegate tableView:tableView viewForFooterInSection:section];
    }else {
        if ([self.dataSourceDelegate respondsToSelector:@selector(footerDataListWithTableView:)] && [self.dataSourceDelegate footerDataListWithTableView:self]){
            id data = [[self.dataSourceDelegate footerDataListWithTableView:self] objectAtIndex:section];
            if ([data isKindOfClass:[QLXTableViewHeaderFooterView class]]) {                ((QLXTableViewHeaderFooterView *)data).tableView = self;
                [(QLXTableViewHeaderFooterView *)data reuseWithData:nil section:section isHeader:false];
                [(QLXTableViewHeaderFooterView *)data refresh];
                [(QLXTableViewHeaderFooterView *)data refreshLayout];
                return data;
            }
            ReuseDataBase * reuseData = (ReuseDataBase *)data;
            assert([ReuseDataBase isSubclassOfClass:[ReuseDataBase class]]);
            
            NSString * reuseIdentifier = [reuseData reuseIdentifier];
            if (reuseIdentifier == nil) {
                reuseIdentifier = self.footerViewReuseIdentifier;
            }
            QLXTableViewHeaderFooterView * view = [self dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
            assert(view && [view isKindOfClass:[QLXTableViewHeaderFooterView class]]);
            view.tableView = self;
            [view reuseWithData:reuseData section:section isHeader:false];
            view.delegate = self.footerDelegate;
            [view refreshLayout];
            return view;
        }
    }
    return nil;
}// custom view for footer. will be adjusted to default or specified footer height
//
//// Accessories (disclosures).
//
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath NS_DEPRECATED_IOS(2_0, 3_0);
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
//
//// Selection
//
//// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
//// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }
    return true;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)]) {
        [self.tableViewDelegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)]) {
        [self.tableViewDelegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    }
}
//
//// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    return indexPath;
}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else {
        
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
        [self.tableViewDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }else {
        
    }
}
//
//// Editing
//
//// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return @"";
}

//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0); // supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
//
//// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    return true;
}
//
//// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]) {
        [self.tableViewDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
    
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]) {
        [self.tableViewDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}
//
//// Moving/reordering
//
//// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }
    return nil;
}
//
//// Indentation
//
//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath; // return 'depth' of row for hierarchies
//
//// Copy/Paste.  All three methods must be implemented by the delegate.
//
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }
    return false;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)]) {
        return [self.tableViewDelegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    return false;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]) {
        [self.tableViewDelegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}


////下拉刷新
//- (void)refreshTableViewDropRefresh:(RefreshTableView *)refreshTableViewDropRefresh success:(void (^)(BOOL result))success{
//    if ([self.tableViewDelegate respondsToSelector:@selector(refreshTableViewDropRefresh:success:)]) {
//        [self.tableViewDelegate refreshTableViewDropRefresh:refreshTableViewDropRefresh success:success];
//    }
//}
////上拉刷新
//- (void)refreshTableViewUpRefresh:(RefreshTableView *)refreshTableViewUpRefresh success:(void (^)(BOOL result))success{
//    if ([self.tableViewDelegate respondsToSelector:@selector(refreshTableViewUpRefresh:success:)]) {
//        [self.tableViewDelegate refreshTableViewUpRefresh:refreshTableViewUpRefresh success:success];
//    }
//}

//下拉刷新
- (void)refreshTableViewDropRefresh:(UITableView *)refreshTableViewDropRefresh{
    if ([self.tableViewDelegate respondsToSelector:@selector(refreshTableViewDropRefresh:)]) {
        [self.tableViewDelegate refreshTableViewDropRefresh:refreshTableViewDropRefresh];
    }
}
//上拉刷新
- (void)refreshTableViewUpRefresh:(UITableView *)refreshTableViewUpRefresh{
    if ([self.tableViewDelegate respondsToSelector:@selector(refreshTableViewUpRefresh:)]) {
        [self.tableViewDelegate refreshTableViewUpRefresh:refreshTableViewUpRefresh];
    }
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.tableViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.tableViewDelegate scrollViewDidScroll:scrollView];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.tableViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.tableViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.tableViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.tableViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


//动画
-(void) openHorizontalAniamtion{
    [self startHorizontalOneByOneAnimation];
    //    [self performSelector:@selector(startHorizontalOneByOneAnimation) withObject:nil afterDelay:0];
}

-(void) openVerticalAniamtion{
    [self startHorizontalOneByOneAnimation];
    //    [self performSelector:@selector(startVerticalOneByOneAnimation) withObject:nil afterDelay:1];
}

-(void) startHorizontalOneByOneAnimation{
    self.hidden = false;
    CGRect frame = self.bounds;
    self.animationCount = self.visibleCells.count;
    self.animating = true;
    int i = 0;
    for (__weak UITableView * cell in self.visibleCells) {
        cell.hidden = true;
        kBlockWeakSelf;
        
        
        [cell.layer addSpringAnimation:KeyPathTypePositionX WithBlock:^(QLXSpringAnimation *animation) {
            animation.fromValue = @(weakSelf.bounds.size.width*1.5);
            animation.damping = 100;
            animation.toValue = @(frame.size.width/2);
            animation.beginTime = CACurrentMediaTime() + (i)*0.05;
            animation.view = cell;
            
            [animation animationStart:^(CAAnimation *anim) {
                ((QLXSpringAnimation *)anim).view.hidden = false;
            }];
            
            [animation animationStop:^(CAAnimation *anim, BOOL finished) {
                weakSelf.animationCount -= 1;
                if (weakSelf.animationCount == 0) {
                    weakSelf.animating = false;
                }
            }];
            
        }];
        i++;
    }
}

-(void) startVerticalOneByOneAnimation{
    self.hidden = false;
    self.animationCount = self.visibleCells.count;
    self.animating = true;
    int i = 0;
    for (__weak UITableView * cell in self.visibleCells) {
        cell.hidden = true;
        kBlockWeakSelf;
        CGRect frame = cell.frame;
        [cell.layer addSpringAnimation:KeyPathTypePositionY WithBlock:^(QLXSpringAnimation *animation) {
            animation.fromValue = @(self.frame.size.height + frame.size.height / 2);
            animation.damping = 100;
            animation.toValue = @(frame.origin.y + frame.size.height / 2);
            animation.beginTime = CACurrentMediaTime() + (i)*0.05;
            animation.view = cell;
            animation.removedOnCompletion = true;
            [animation animationStart:^(CAAnimation *anim) {
                ((QLXSpringAnimation * )anim).view.hidden = false;
            }];
            [animation animationStop:^(CAAnimation *anim, BOOL finished) {
                weakSelf.animationCount -= 1;
                if (weakSelf.animationCount == 0) {
                    weakSelf.animating = false;
                }
            }];
        }];
        i++;
    }
}

-(void) setAnimating:(BOOL)animating{
    _animating = animating;
    if (animating) {
        // self.userInteractionEnabled = false;
    }else{
        //self.userInteractionEnabled = true
    }
    
}

- (void)reloadData{
    if (self.isAnimating) {
        
    }else {
        [super reloadData];
    }
}

-(void) reloadDataWithAnimation{
    [self beginUpdates];
    [self endUpdates];
    
}



/**
 *  缓存cell 字典
 */
-(NSMutableDictionary *)cacheCellDic{
    if (!_cacheCellDic) {
        _cacheCellDic = [NSMutableDictionary new];
    }
    return _cacheCellDic;
}

-(NSMutableDictionary *)cacheHeaderViewDic{
    if (!_cacheHeaderViewDic) {
        _cacheHeaderViewDic = [NSMutableDictionary new];
    }
    return _cacheHeaderViewDic;
}

-(NSMutableDictionary *)cacheFooterViewDic{
    if (!_cacheFooterViewDic) {
        _cacheFooterViewDic = [NSMutableDictionary new];
    }
    return _cacheFooterViewDic;
}

-(QLXTableViewCell *) getCacheCellWithReuseIdentifier:(NSString *)identifier{
    if (identifier == nil) {
        identifier = self.cellReuseIdentifier;
    }
    assert(identifier); // 未注册cell 类
    QLXTableViewCell * cacheCell = [self.cacheCellDic objectForKey:identifier];
    if (!cacheCell) {
        [self registerCellClass:NSClassFromString(identifier)];
        cacheCell = [[NSClassFromString(identifier) alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        cacheCell.width = self.width;
        assert(cacheCell);  //identifier 错误 不是类名
        assert([cacheCell isKindOfClass:[QLXTableViewCell class]]);
        cacheCell.tableView = self;
        [self.cacheCellDic setObject:cacheCell forKey:identifier];
    }
    return cacheCell;
}

-(QLXTableViewHeaderFooterView *) getCacheHeaderViewWithReuseIdentifier:(NSString *)identifier{
    if (identifier == nil) {
        identifier = self.headerViewReuseIdentifier;
    }
    if (!identifier) {
        return nil;
    }
    QLXTableViewHeaderFooterView * cacheHeaderView = [self.cacheHeaderViewDic objectForKey:identifier];
    if (!cacheHeaderView) {
        [self registerHeaderClass:NSClassFromString(identifier)];
        cacheHeaderView = [[NSClassFromString(identifier) alloc] initWithReuseIdentifier:identifier];
        assert(cacheHeaderView);  //identifier 错误 不是类名
        assert([cacheHeaderView isKindOfClass:[QLXTableViewHeaderFooterView class]]);
        cacheHeaderView.tableView = self;
        [self.cacheHeaderViewDic setObject:cacheHeaderView forKey:identifier];
    }
    return cacheHeaderView;
}

-(QLXTableViewHeaderFooterView *) getCacheFooterViewWithReuseIdentifier:(NSString *)identifier{
    if (identifier == nil) {
        identifier = self.footerViewReuseIdentifier;
    }
    if (!identifier) {
        return nil;
    }
    QLXTableViewHeaderFooterView * cacheFooterView = [self.cacheFooterViewDic objectForKey:identifier];
    if (!cacheFooterView) {
        [self registerFooterClass:NSClassFromString(identifier)];
        cacheFooterView = [[NSClassFromString(identifier) alloc] initWithReuseIdentifier:identifier];
        
        assert(cacheFooterView);  //identifier 错误 不是类名
        assert([cacheFooterView isKindOfClass:[QLXTableViewHeaderFooterView class]]);
        cacheFooterView.tableView = self;
        [self.cacheFooterViewDic setObject:cacheFooterView forKey:identifier];
    }
    return cacheFooterView;
}

-(QLXRefreshFooterView *)refreshFooter{
    QLXRefreshFooterView * rf = [super refreshFooter];
    if (rf) {
        if (self.contentH == 0) {
            rf.hidden = true;
        }else if(rf && rf.hidden){
            [GCDQueue executeInMainQueue:^{
                rf.hidden = false;
            } afterDelaySecs:0.2];
        }
    }
    return rf;
}


-(void)excuteFadeInAnimation{
    int i = 0;
    CGFloat height = ((UIView *)(self.visibleCells.firstObject)).height * 0.7;
    
    for (QLXTableViewCell * cell in self.visibleCells) {
        CGRect oldFrmae = cell.frame;
        if (i == 0) {
            cell.height -= height;
        }else {
            cell.y -= height ;
        }
        cell.alpha = 0;
        [UIView animateWithDuration:0.3f delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
            cell.frame = oldFrmae;
            cell.alpha = 1;
        } completion:nil];
        i++;
    }
    
    self.refreshFooter.y -= height;
    [UIView animateWithDuration:0.3f delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.refreshFooter.y += height;
    } completion:nil];
}


-(BOOL)touchesShouldCancelInContentView:(UIView *)view{
    if ([view isKindOfClass:[UIControl class]]) {
        return true;
    }
    return [super touchesShouldCancelInContentView:view];
}


-(void)setAdEnable:(BOOL)adEnable{
    _adEnable = adEnable;
    if (adEnable) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
        [self performSelector:@selector(autoMoveNextPage) withObject:nil afterDelay:2];
    }else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
    }
}

-(void) autoMoveNextPage{
    if (self.adEnable) {
        if(self.isDecelerating == false && self.isTracking == false ){
            
            CGFloat offset =fmax(0,fmin( self.offsetY + self.height,self.contentH - self.height));
            if (self.offsetY + self.height + 1 > self.contentH ) {
                offset = 0;
            }
            [self setContentOffset:CGPointMake(0,offset) animated:true];
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
        [self performSelector:@selector(autoMoveNextPage) withObject:nil afterDelay:2];
    }
}


-(void)onExit{
    [super onExit];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
}


-(void)setPreRefreshDistance:(CGFloat)preRefreshDistance{
    self.refreshFooter.preRefreshDistance = preRefreshDistance;
}

/**
 *  重新加载 伴随动画 水平渐入
 */
-(void) reloadDataWithHorizontalOneByOneAnimation{
    [self reloadData];
    [self openHorizontalAniamtion];
}

/**
 *  重新加载 伴随动画 竖直渐入
 */
-(void) reloadDataWithVerticalOneByOneAnimation{
    [self reloadData];
    [self openVerticalAniamtion];
}


@end
