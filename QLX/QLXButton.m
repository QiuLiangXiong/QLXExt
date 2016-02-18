//
//  QLXButton.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/11/5.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXButton.h"

@implementation QLXButton

-(void)onEnter{
    [super onEnter];
}

-(void)onTouchDown{
    
}

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    for (UIView * sub in self.subviews) {
        if ([sub isKindOfClass:[UIImageView class]]) {
            UIImageView * iv = (UIImageView *)sub;
            [iv setHighlighted:highlighted];
        }
    }
}


@end
