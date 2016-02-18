//
//  QLXScrollView.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/16.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXScrollView.h"
#import "QLXExt.h"

@implementation QLXScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(BOOL)touchesShouldCancelInContentView:(UIView *)view{
    if ([view isKindOfClass:[UIControl class]]) {
        return true;
    }
    return [super touchesShouldCancelInContentView:view];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    BOOL result = true;
    if ([self.delegate respondsToSelector:@selector(scrollView:gestureRecognizerShouldBegin:)]) {
        result = [((id<QLXScrollViewDelegate>)self.delegate) scrollView:self gestureRecognizerShouldBegin:gestureRecognizer];
    }
    if (result) {
        result = [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return  result;
}

-(void)setContentOffset:(CGPoint)contentOffset{
    CGPoint old = [super contentOffset];
    if (CGPointEqualToPoint(old, contentOffset) == false) {
        if ([self.delegate respondsToSelector:@selector(scrollView:oldContentOffset:newContentOffset:)]) {
            [((id<QLXScrollViewDelegate>)self.delegate) scrollView:self oldContentOffset:old newContentOffset:contentOffset];
        }
    }
    [super setContentOffset:contentOffset];
}

-(CGSize)contentSize{
    if ([self.delegate respondsToSelector:@selector(getContentSizeWithScrollView:)]) {
        return [((id<QLXScrollViewDelegate>)self.delegate) getContentSizeWithScrollView:self];
    }
    return [super contentSize];
}

@end
