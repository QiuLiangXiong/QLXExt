//
//  QLXCollectionViewHorizalScaleLayout.h
//  FunPoint
//
//  Created by QLX on 15/12/22.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QLXCollectionViewHorizalScaleLayoutDelegate;
@interface QLXCollectionViewHorizalScaleLayout : UICollectionViewFlowLayout



@property(nonatomic , assign) CGFloat itemSpace;   // 不同cell的间距 默认等于15
@property(nonatomic , assign) BOOL pagingEnable;   // 是否分页滑动
@property(nonatomic , assign) CGFloat scale;   // cell 最小缩放值  默认0.5
@property (nonatomic, weak) id<QLXCollectionViewHorizalScaleLayoutDelegate> delegate;

@end

@protocol QLXCollectionViewHorizalScaleLayoutDelegate <NSObject>
@optional
/**
 *  获得的关于cell的缩放 百分比 [0.5 , 1] 值区间  0.5 代表cell 高度最小时  1代表 cell 高度最大时
 *
 */
-(void) collctionViewLayout:(QLXCollectionViewHorizalScaleLayout *)layout indexPath:(NSIndexPath *)indePath withScale:(CGFloat) aScale;

@end