//
//  QLXImageView.m
//  fcuhConsumer
//
//  Created by QLX on 16/1/22.
//  Copyright © 2016年 avatar. All rights reserved.
//

#import "QLXImageView.h"
#import "QLXExt.h"

@implementation QLXImageView

-(void)setBounds:(CGRect)bounds{
    
    if (self.aspectRatio > 0 &&(bounds.size.width + bounds.size.height > 0)) {
        CGFloat aspectRatio = 0;
        if (bounds.size.height > 0) {
             aspectRatio = bounds.size.width / bounds.size.height;
        }
        if (aspectRatio == 0 || fabs(self.aspectRatio - aspectRatio) > 0.1) {
            CGFloat height = bounds.size.width / self.aspectRatio;
            self.height = height;
            if (self.translatesAutoresizingMaskIntoConstraints == false) {
                [self mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(height);
                }];
            }

        }
    }
    [super setBounds:bounds];
}


@end
