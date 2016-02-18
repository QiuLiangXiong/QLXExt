//
//  QLXScaleView.h
//  fcuhConsumer
//  缩放回调的view  会根据最初设置的frame 如果frame相对于最初的frame有缩放 会进行相应回调
//  Created by QLX on 15/12/29.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXView.h"

@protocol QLXScaleViewDelegate;

@interface QLXScaleView : QLXView

@property(nonatomic , assign) CGSize originSize;
@property(nonatomic , weak) id<QLXScaleViewDelegate> delegate;

+(instancetype) createWithOriginSize:(CGSize) size delegate:(id<QLXScaleViewDelegate>) delegate;

@end

@protocol QLXScaleViewDelegate <NSObject>

/**
 *  缩放回调
 *
 *  @param scaleView
 *  @param widthScale  新宽度相对于originSize的 比例
 *  @param heightScale 新高度相对于originSize的 比例
 */
-(void) scaleView:(QLXScaleView *)scaleView widthScale:(CGFloat) widthScale heightScale:(CGFloat) heightScale;

@end