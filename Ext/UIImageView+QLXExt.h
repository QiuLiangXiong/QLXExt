//
//  UIImageView+QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ImageViewAnimationNone,
    ImageViewAnimationFade
} ImageViewAnimationType;
@interface UIImageView(QLXExt)

+ (instancetype)createWithImageName:(NSString* ) name;
+ (instancetype)createWithImage:(UIImage* ) image;
+ (instancetype)create;
-(void)setScaleToFitWithImage:(UIImage *)image;


-(void) sizeToFitImage;


-(void) setImageWithURL:(NSString *) url placeholderImage:(UIImage *)placeholder animationType:(ImageViewAnimationType) type;

@end
