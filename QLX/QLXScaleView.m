//
//  QLXScaleView.m
//  fcuhConsumer
//
//  Created by QLX on 15/12/29.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXScaleView.h"

@implementation QLXScaleView

+(instancetype) createWithOriginSize:(CGSize) size delegate:(id<QLXScaleViewDelegate>) delegate{
    QLXScaleView * view = [self new];
    view.backgroundColor = [UIColor clearColor];
    view.originSize = size;
    view.delegate = delegate;
    return view;
}


-(void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    if ([self.delegate respondsToSelector:@selector(scaleView:widthScale:heightScale:)]) {
        CGFloat widthScale = bounds.size.width / self.originSize.width;
        CGFloat heightScale = bounds.size.height/ self.originSize.height;
        [self.delegate scaleView:self widthScale:widthScale heightScale:heightScale];
    }
}


@end
