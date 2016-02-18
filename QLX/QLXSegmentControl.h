//
//  QLXSegmentControl.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/28.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXCollectionView.h"

typedef enum{
    // Likewise, the horizontal positions are mutually exclusive to each other.
    QLXSegmentScrollPositionDefault              = 0,
    QLXSegmentScrollPositionLeft,
    QLXSegmentScrollPositionCenteredHorizontally,
    QLXSegmentScrollPositionRight
}QLXSegmentScrollPosition;

@class QLXSegmentControl;

@protocol QLXSegmentControlDelegate <NSObject>

@optional

/**
 *  自定义item的view 实现这个代理
 *  QLXSegmentItemData 派生类 的数组
 *  提供数据源  数据驱动view的显示  对应的view 是 QLXSegmentItem派生类
 *  @return
 */
-(NSMutableArray *) itemDataListWithSegmentControl:(QLXSegmentControl *)segment;

/**
 *  选中变化 回调
 *
 *  @param segment
 *  @param index   第几个被选中
 */
-(void) segmentControl:(QLXSegmentControl *)segment valueChangedWithIndex:(NSInteger)index;

@end


@interface QLXSegmentControl : UIControl


@property(nonatomic , weak) id<QLXSegmentControlDelegate> delegate;
// 这个要设置 选中背景 这个view的frame会随着item内容变化（做好支持
@property (nonatomic, strong) UIView  * selectBackgoundView;

@property (nonatomic, assign) BOOL    scrollEnable;// 是否支持滚动选择

@property (nonatomic, strong) UIFont  * font;// 有默认字体
@property (nonatomic, strong) UIColor * normalColor;// 默认文本颜色
@property (nonatomic, strong) UIColor * selectColor;// 选中文本颜色
@property (nonatomic, assign) CGFloat titleSpace;  //标题间距 有默认

@property (nonatomic, assign) QLXSegmentScrollPosition scrollPosition;  // 滚动方式

@property (nonatomic, assign) NSUInteger selectedIndex; // 第几个被选中  可以自定义初始化第几个被选中
@property (nonatomic, strong) NSArray * titles;// 标题数组;
@property (nonatomic, strong) QLXCollectionView * collectionView;

/**
 *  使用默认的分段文本布局
 *
 *  @param titles 文本数组
 *
 *  @return
 */
-(instancetype)initWitTitles:(NSArray *)titles;

/**
 *  百分比来设置选中背景selectBackgoundView 的位置 一般用来配合 scroll'view 的分页滑动进度 来同步进度效果  一般配合paveview 的使用
 *
 *  @param value [-1 ,1];  值区间 
 */
-(void) scrollSelectBackgroundViewWithProgressValue:(CGFloat) value fromIndex:(NSInteger)index;
/**
 *  整体滚动百分比  一般配合pageview 使用
 *
 *  @param value [0, 1];
 */
-(void) scrollContentOffsetWithProgerss:(CGFloat) value;

/**
 *  刷新
 *  数据源头 变化了 可以调用这个刷新显示
 */
-(void) reloadData;

@end



