//
//  QLXSegmentControl.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/28.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXSegmentControl.h"
#import "QLXExt.h"
#import "QLXSegmentItemData.h"
#import "QLXSegmentItem.h"

@interface QLXSegmentControl()<QLXCollectionViewDelegate , QLXCollectionViewDataSourceDelegate>


@property (nonatomic, strong) NSMutableArray * dataList; // 数据源
@property (nonatomic, assign) BOOL animating;
@property(nonatomic , assign) BOOL reloading;

@end

@implementation QLXSegmentControl

+(instancetype) createWithTitles:(NSArray *)titles{
    return [[self alloc] initWitTitles:titles];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initConfigs];
    }
    return self;
}

-(instancetype)initWitTitles:(NSArray *)titles{
    self = [self init];
    if (self) {
        self.titles = titles;
    }
    return self;
}

-(void) initConfigs{
    self.backgroundColor = [UIColor clearColor];
    [self.collectionView constraintWithEdgeZero];
    self.scrollEnable = true;
    self.reloading = true;
}

// 下一帧初始化
-(void)onEnter{
    [super onEnter];
    // 添加选中背景
    if (self.selectBackgoundView) {
        [self.collectionView addSubview:self.selectBackgoundView];
    }
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
}

-(void) initDataList{
    if (self.dataList == nil && self.titles) {
        
    }else {
        
    }
}

-(void)onExit{
    [super onExit];
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

-(QLXCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [QLXCollectionView createWithFlowLayout];
        _collectionView.dataSourceDelegate = self;
        _collectionView.delegate = self;
        [_collectionView setBounces:false];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.allowsMultipleSelection = false;
        [((UICollectionViewFlowLayout *)_collectionView.layout) setScrollDirection:(UICollectionViewScrollDirectionHorizontal)];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - QLXCollectionViewDataSourceDelegate

-(NSMutableArray *) cellDataListWithCollectionView:(QLXCollectionView *)collectionView{
    return self.dataList;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize newSize = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
        CGSize oldSize = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
        if (newSize.width != oldSize.width) {
            [self adjustLayoutWithWidth:newSize.width];
        }
    }
}

// 调整 布局
-(void) adjustLayoutWithWidth:(CGFloat) width{
    CGFloat offset = self.width - width;
    if (offset < 0 && self.scrollEnable) {
        offset = 0;
    }
    if (offset) {
        for (ReuseDataBase * data in self.dataList) {
            data.width = data.width + (offset / self.dataList.count);
            [data heightChanged];
        }
        [self.collectionView reloadData];
    }
    // 更新选中背景图
    
    if (self.reloading) {
        self.reloading = false;
        kBlockWeakSelf;
        [self performInNextLoopWithBlock:^{
            if (weakSelf.selectedIndex >= weakSelf.dataList.count) {
                _selectedIndex = weakSelf.dataList.count - 1;
            }
            [weakSelf scrollToSelectWithAnimated:false];
        }];
        
    }
   
    
}



-(UIFont *)font{
    if (!_font) {
        _font = [UIFont systemFontOfSize:17];
    }
    return _font;
}

-(UIColor *)normalColor{
    if (!_normalColor) {
        _normalColor = [UIColor colorWithHexString:@"#c4c4c4"];
    }
    return _normalColor;
}

-(UIColor *)selectColor{
    if (!_selectColor) {
        _selectColor = [UIColor whiteColor];
    }
    return _selectColor;
}


-(CGFloat)titleSpace{
    if (_titleSpace == 0) {
        _titleSpace = 30; // 默认三十的字体间距
    }
    return _titleSpace;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row; // 选中
}

-(UICollectionViewScrollPosition) getScrollPosition{
    switch (self.scrollPosition) {
        case QLXSegmentScrollPositionDefault:
            return UICollectionViewScrollPositionNone;
            break;
        case QLXSegmentScrollPositionLeft:
            return UICollectionViewScrollPositionLeft;
            break;
        case QLXSegmentScrollPositionCenteredHorizontally:
            return UICollectionViewScrollPositionCenteredHorizontally;
            break;
        case QLXSegmentScrollPositionRight:
            return UICollectionViewScrollPositionRight;
            break;
        default:
            break;
    }
    return UICollectionViewScrollPositionNone;
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    if (_selectedIndex != selectedIndex ) {
        _selectedIndex = selectedIndex;
        [self scrollToSelectWithAnimated:true];
        [self sendDlegateWithIndex:selectedIndex];
    }
}



// 发送代理事件
-(void)sendDlegateWithIndex:(NSInteger )index{
    if ([self.delegate respondsToSelector:@selector(segmentControl:valueChangedWithIndex:)]) {
        [self.delegate segmentControl:self valueChangedWithIndex:index];
    }
    [self sendActionsForControlEvents:(UIControlEventValueChanged)];// 发送选中变化事件
}

-(void) scrollToSelectWithAnimated:(BOOL ) animated{
    if (_selectedIndex < self.dataList.count) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:animated scrollPosition:([self getScrollPosition])];
    }
    [self scrollWithProgress:self.selectedIndex * 1.0 / (self.dataList.count -1)animated:animated];
    [self scrollSelectBackgroundViewWithProgressValue:0 fromIndex:self.selectedIndex animated:animated];
}

-(UIView *)selectBackgoundView{
    if (_selectBackgoundView) {
        [_selectBackgoundView sendToBack];
    }
    return _selectBackgoundView;
}

// 根据百分比 滚动自身内容偏移量
-(void) scrollContentOffsetWithProgerss:(CGFloat) value{
    if (!self.animating && self.scrollPosition == QLXSegmentScrollPositionDefault) {
        [self scrollWithProgress:value animated:false];
    }
    
}

-(void) scrollWithProgress:(CGFloat) value animated:(BOOL) animated{
    if (self.scrollPosition == QLXSegmentScrollPositionDefault) {
        kBlockWeakSelf;
        if (weakSelf.collectionView.contentSize.width - weakSelf.width <= 0) {
            self.collectionView.contentOffset = CGPointZero;
        }else {
            if (animated) {
                kBlockWeakSelf;
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint point  = CGPointMake((weakSelf.collectionView.contentSize.width - weakSelf.width) * value, 0);
                    weakSelf.collectionView.contentOffset = point;
                } ];
            }else {
                CGPoint point  = CGPointMake((self.collectionView.contentSize.width - self.width) * value, 0);
                self.collectionView.contentOffset = point;
            }
        }
        
    }
}

// 滚动选中背景
-(void) scrollSelectBackgroundViewWithProgressValue:(CGFloat) value fromIndex:(NSInteger)index{
    if (!self.animating) {
       [self scrollSelectBackgroundViewWithProgressValue:value fromIndex:index animated:false];
    }
    
}



-(void) scrollSelectBackgroundViewWithProgressValue:(CGFloat) value fromIndex:(NSInteger)index animated:(BOOL) animated{
    if (self.selectBackgoundView && index < self.dataList.count) {
        CGFloat x = 0 ;
        for (int i = 0 ; i < self.dataList.count; ++i) {
            if (i == index) {
                break;
            }
            x += ((ReuseDataBase *)[self.dataList objectAtIndex:i]).width;
        }
        BOOL change = true;
        CGFloat width = 0;
        
        CGFloat curWidth = ((ReuseDataBase *)[self.dataList objectAtIndex:index]).width;
        if (value < 0 && index) {
            CGFloat lastWidth = ((ReuseDataBase *)[self.dataList objectAtIndex:index - 1]).width;
            width = curWidth + (lastWidth - curWidth) * fabs(value);
            x = (x + curWidth) - (curWidth * fabs(value)) - width;
        }else if(value > 0 && index < (self.dataList.count - 1)){
            CGFloat nextWidth = ((ReuseDataBase *)[self.dataList objectAtIndex:index + 1]).width;
            width = curWidth + (nextWidth - curWidth) * fabs(value);
            x =  x + (curWidth * fabs(value)) ;
        }else if(value == 0){
            width = curWidth;
        }else{
            change = false;
        }
        //  self.selectBackgoundView.frame = CGRectMake(x, 0, width, self.height);
        if (animated) {
            kBlockWeakSelf;
            self.animating = true;
            [UIView animateWithDuration:0.32 animations:^{
                weakSelf.selectBackgoundView.frame = CGRectMake(x, 0, width, self.height);
            } completion:^(BOOL finished) {
                weakSelf.animating = false;
            }];
        }else {
            if (self.animating == false) {
                self.selectBackgoundView.frame = CGRectMake(x, 0, width, self.height);
            }
        }
    }
}

-(void)reloadData{
    self.dataList = nil;
    self.reloading = true;
    [self.collectionView reloadData];
    
}

-(void)setAnimating:(BOOL)animating{
    _animating = animating;
    self.userInteractionEnabled = !_animating;
}

-(NSMutableArray *)dataList{
    if (!_dataList) {
        if (self.titles) {
            _dataList = [NSMutableArray new];
            [self.collectionView registerCellClass:[QLXSegmentItem class]];
            for (NSString * title in self.titles) {
                QLXSegmentItemData * data = [QLXSegmentItemData new];
                data.title = title;
                data.titleSpace = self.titleSpace;
                data.font = self.font;
                data.normalColor = self.normalColor;
                data.selectorColor = self.selectColor;
                [_dataList addObject:data];
            }
        }else if([self.delegate respondsToSelector:@selector(itemDataListWithSegmentControl:)]){
            _dataList = [self.delegate itemDataListWithSegmentControl:self];
        }
    }
    return _dataList;
}

-(void)setDelegate:(id<QLXSegmentControlDelegate>)delegate{
    _delegate = delegate;
    self.collectionView.cellDelegate = (id<QLXCollectionViewCellDelegate>)delegate;
}


@end
