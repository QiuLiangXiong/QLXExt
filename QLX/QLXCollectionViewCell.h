//
//  QLXCollectionViewCell.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/22.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXCollectionView.h"
@class QLXStaticCell;
@class QLXCollectionView;
@class QLXCollectionViewCell;

@class ReuseDataBase;
@protocol  QLXCollectionViewCellDelegate;

@interface QLXCollectionViewCell : UICollectionViewCell

@property(nonatomic , weak) QLXCollectionView * collectionView;
@property(nonatomic , strong) ReuseDataBase * data;
@property(nonatomic , strong) NSIndexPath * indexPath;
@property(nonatomic , weak) id<QLXCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) UIView * view; //cell内容容器 cell 的视图都要 [self.view addSubview:subview];
@property(nonatomic , assign) BOOL dynamicCellSize; // 是否为动态大小  默认为静态 如果不是要设置为true才行

-(void) createUI;

-(void) reuseWithData:(ReuseDataBase *) data indexPath:(NSIndexPath *) indexPath;


-(CGSize) cellSize;


/**
 *  需要在子类里重写
 *
 *  @return cell 的宽度
 */
-(CGFloat) cellWidth;

-(CGFloat) cellHeight;


/**
 *  刷新 可重写
 */
-(void) refresh;

/**
 *  选中该cell
 */
-(void) selectedCell;

/**
 *  取消选中
 */
-(void) deSelectedCell;

@end


@protocol QLXCollectionViewCellDelegate <NSObject>

@optional

//// 主动请求刷新数据
//
//-(void) reloadWithcollectionViewCell:(QLXCollectionViewCell *)cell;


// 初始化这个cell的时候回调应用这个代理  实现代理者可以对这个对象进行配置
-(void) initToConfigtWithCollectionViewCell:(QLXCollectionViewCell *)cell;


@end


