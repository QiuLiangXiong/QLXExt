//
//  QLXShapeLayer.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/10/22.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIKit/UIKit.h"

@interface QLXShapeLayer : CAShapeLayer

+(instancetype) create;

/**
 *  产生一个矩形形遮罩
 *
 *  @param frame  在 view 坐标系下 的 区域
 *
 *  @return
 */
+(instancetype) createWithMaskFrame:(CGRect)frame view:(UIView *) view;

/**
 *  用maskview 的frame 来 作为遮罩区域
 *
 *  @param maskView
 *  @param view
 *
 *  @return <#return value description#>
 */
+(instancetype) createWithMaskView:(UIView *)maskView view:(UIView *) view;

@end
