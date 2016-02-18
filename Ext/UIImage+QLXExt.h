//
//  UIImage+QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/13.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(QLXExt)
- (UIImage *) changedToSize:(CGSize) size;
/**
 *  图片转换为Base64 字符串
 *
 *  @return Base64 字符串
 */
-(NSString* ) convertToBase64String;

+(NSString *) convertToBase64StringWithImage:(UIImage *) image;

/**
 *  获取图片某一点的颜色
 *
 *  @param point 图片上的额一点
 *
 *  @return 对应颜色  可能为nil（越界）
 */
- (UIColor *)colorAtPixel:(CGPoint)point;
/**
 *  根据颜色 生成相应大小的图片
 *
 *  @param color
 *  @param size
 *
 *  @return
 */
+(instancetype) imageWithColor:(UIColor *) color size:(CGSize) size;

+(instancetype) imageWithHexColor:(NSString *) hexStr;


//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size;

// 矢量化 保留边缘四角
-(UIImage *) resizableImage;
@end
