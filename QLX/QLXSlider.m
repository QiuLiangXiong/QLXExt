//
//  QLXSlider.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/11/7.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXSlider.h"
#import "QLXExt.h"

@implementation QLXSlider


//- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds{
//    bounds = [super minimumValueImageRectForBounds:bounds];
//    if (self.trackHeight) {
//        return CGRectMake(bounds.origin.x, (self.height - self.trackHeight)/2, 10 , self.trackHeight);
//    }
//    return bounds;
//}


//- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
//    bounds = [super maximumValueImageRectForBounds:bounds];
//    if (self.trackHeight) {
//        return CGRectMake(bounds.origin.x, (self.height - self.trackHeight)/2, bounds.size.width, self.trackHeight);
//    }
//    return bounds;
//}


- (CGRect)trackRectForBounds:(CGRect)bounds{
    bounds = [super trackRectForBounds:bounds];
    if (self.trackHeight) {
        return CGRectMake(5, (self.height - self.trackHeight)/2, self.width -10 , self.trackHeight);
    }
    return bounds;
}
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    if (self.thumbHeight) {
        return CGRectMake(0, 0, self.width, self.thumbHeight);
    }
    return [super thumbRectForBounds:bounds trackRect:rect value:value];
}

@end
