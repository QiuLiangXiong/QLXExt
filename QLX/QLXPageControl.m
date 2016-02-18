//
//  QLXPageControl.m
//  QLXExtDemo
//
//  Created by QLX on 15/11/1.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXPageControl.h"
#import "QLXExt.h"

@interface QLXPageControl()

@property(nonatomic , assign) BOOL needUpdate;

@end
@implementation QLXPageControl


-(void)setNormalImage:(UIImage *)normalImage{
    _normalImage = normalImage;
    self.needUpdate = true;
}

-(void)setSelectedImage:(UIImage *)selectedImage{
    _selectedImage = selectedImage;
    self.needUpdate = true;
}

-(void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    self.needUpdate = true;
}

-(void)setNeedUpdate:(BOOL)needUpdate{
    _needUpdate = needUpdate;
    if (needUpdate) {
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews{
    if (self.needUpdate) {
        self.needUpdate = false;
        [self updateDotsImage];
    }
    [super layoutSubviews];
}

-(void) updateDotsImage{
    if (self.normalImage || self.selectedImage) {
        for (int i = 0 ; i < self.subviews.count; i++) {
            UIImageView * dot = [self.subviews objectAtIndex:i];
            if (self.currentPage == i && self.selectedImage) {
                dot.image = self.selectedImage;
            }else if(self.normalImage){
                dot.image = self.normalImage;
            }
        }
    }
}

@end
