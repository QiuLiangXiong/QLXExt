//
//  QLXCollectionViewScaleLayout.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/11/18.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QLXCollectionViewScaleLayoutDelegate;


@interface QLXCollectionViewScaleLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<QLXCollectionViewScaleLayoutDelegate> delegate;
@property(nonatomic , assign) CGFloat minScale;  // 缩放系数  默认值 0.45

@end


@protocol QLXCollectionViewScaleLayoutDelegate <NSObject>
@optional
/**
 *  获得的关于cell的缩放 百分比 [0.45 , 1] 值区间  0.45 代表cell 高度最小时  1代表 cell 高度最大时
 *
 */
-(void) collctionViewLayout:(QLXCollectionViewScaleLayout *)layout indexPath:(NSIndexPath *)indePath withScale:(CGFloat) aScale;

@end