//
//  QLXCollectionView.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/21.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXCollectionViewCell.h"
#import "QLXCollectionReusableView.h"
#import "QLXRefreshBaseView.h"
#import "QLXRefreshHeaderView.h"
#import "QLXRefreshFooterView.h"
@protocol QLXCollectionViewDataSourceDelegate;
@protocol QLXCollectionReusableViewDelegate;
@protocol QLXCollectionViewDelegate;
@protocol QLXCollectionViewCellDelegate;
@class QLXRefreshFooterView;
@class QLXRefreshHeaderView;

@interface QLXCollectionView : UICollectionView

@property(nonatomic , weak)   id<QLXCollectionViewDataSourceDelegate> dataSourceDelegate;
@property(nonatomic , weak)   id<QLXCollectionViewDelegate> collectionViewDelegate;
@property(nonatomic , weak)   id<QLXCollectionViewCellDelegate> cellDelegate;
@property(nonatomic , weak)   id<QLXCollectionReusableViewDelegate> headerDelegate;
@property(nonatomic , weak)   id<QLXCollectionReusableViewDelegate> footerDelegate;
@property (nonatomic, weak)   id<UICollectionViewDelegateFlowLayout> layoutDelegate;
@property (nonatomic, weak)   UICollectionViewLayout * layout;
@property (nonatomic, assign) BOOL adEnable;   // 是否轮播
@property (nonatomic, assign) CGFloat adPageWidth;   // 轮播翻页下一个宽度  默认是self.frame.width
@property (nonatomic, assign) CGFloat adOffsetRatio;   //  用剩余偏移比例判断是否轮播到最后一页 默认1.0

@property(nonatomic , assign) NSInteger curPage;  // 当前是第几页

@property(nonatomic , assign) CGFloat preRefreshDistance;  // 提前预刷新距离

@property(nonatomic , assign) BOOL highlighted;


@property(nonatomic , assign) BOOL refreshEnable;           // 是否支持刷新

@property(nonatomic , assign) BOOL scrolling ;  // 是否在滚动中



/**
 * 便利构造
 * 默认的流布局
 */
+(instancetype) createWithFlowLayout;

+(instancetype) createWithLayout:(UICollectionViewLayout *)layout;

-(void) registerCellClass:(Class)cellClass ;

-(void) registerHeaderClass:(Class) headerClass;

-(void) registerFooterClass:(Class) footerClass;

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

@end





// delegate
@protocol QLXCollectionViewDelegate <UICollectionViewDelegate>

@optional
//下拉刷新
- (void)refreshCollectionViewDropRefresh:(QLXCollectionView *)collectionView;
//上拉刷新
- (void)refreshCollectionViewUpRefresh:(QLXCollectionView *)collectionView;

@end


@protocol QLXCollectionViewDataSourceDelegate <NSObject>

@optional

/**
 * cell数据源
 *
 * 否则 返回 ReuseDataBase 类型组成的数据 数组
 */
-(NSMutableArray *) cellDataListWithCollectionView:(QLXCollectionView *)collectionView;
/**
 *
 *  头部数据源
 *  @param NSMutableArray
 *
 *  @return
 */
-(NSMutableArray *) headerDataListWithCollectionView:(QLXCollectionView *)collectionView;
/**
 *  尾部数据源
 *
 *  @return
 */
-(NSMutableArray *) footerDataListWithCollectionView:(QLXCollectionView *)collectionView;

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;


@end