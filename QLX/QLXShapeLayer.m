//
//  QLXShapeLayer.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/10/22.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXShapeLayer.h"


@interface QLXShapeLayer()

@property (nonatomic, assign) CGRect maskFrame;
@property (nonatomic, weak) UIView * maskView;
@property (nonatomic, assign) BOOL firstEnter;
@property (nonatomic, weak) UIView * view;

@end
@implementation QLXShapeLayer

+(instancetype) create{
    QLXShapeLayer * layer = [[self alloc] init];
    layer.lineWidth = 0.001;
    layer.fillRule = kCAFillRuleEvenOdd;
    [layer setNeedsLayout];
    return layer;
}

+(instancetype) createWithMaskFrame:(CGRect)frame view:(UIView *) view{
    QLXShapeLayer * layer = [self create];
    if (layer) {
        layer.maskFrame = frame;
        layer.view = view;
    }
    return layer;
}

+(instancetype) createWithMaskView:(UIView *)maskView view:(UIView *) view{
    QLXShapeLayer * layer = [self create];
    if (layer) {
        layer.maskView = maskView;
        layer.view = view;
    }
    return layer;
}



-(void)layoutSublayers{
    if (!self.firstEnter) {
        self.firstEnter = true;
        [self onEnter];
    }
    [super layoutSublayers];
}



-(void) onEnter{
    if ((self.maskFrame.size.width + self.maskFrame.size.height != 0) || self.maskView) {
        if (self.maskView) {
            self.maskFrame = self.maskView.frame;
        }
        self.path = [self getMaskFramePath].CGPath;
    }
}

-(UIBezierPath *) getMaskFramePath{
    UIBezierPath * path = [UIBezierPath new];
    [path moveToPoint:CGPointZero];
    CGSize size = self.view.frame.size;
    [path addLineToPoint:CGPointMake(size.width, 0)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    [path addLineToPoint:CGPointMake(0, size.height)];
    [path addLineToPoint:CGPointMake(0, 0)];
    
    size = self.maskFrame.size;
    [path moveToPoint:self.maskFrame.origin];
    [path addLineToPoint:CGPointMake(self.maskFrame.origin.x + size.width, self.maskFrame.origin.y)];
    [path addLineToPoint:CGPointMake(self.maskFrame.origin.x + size.width, self.maskFrame.origin.y + size.height)];
    [path addLineToPoint:CGPointMake(self.maskFrame.origin.x , self.maskFrame.origin.y + size.height)];
    [path addLineToPoint:self.maskFrame.origin];
    return path;
    
}


@end
