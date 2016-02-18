//
//  QLXScrollView.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/16.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QLXScrollViewDelegate;
@interface QLXScrollView : UIScrollView


@end


@protocol QLXScrollViewDelegate <UIScrollViewDelegate>

@optional

- (BOOL)scrollView:(UIScrollView *)scrollView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

- (void)scrollView:(UIScrollView *)scrollView   oldContentOffset:(CGPoint) oldContentOffset  newContentOffset:(CGPoint) newContentOffset;
- (CGSize) getContentSizeWithScrollView:(UIScrollView *)scrollView ;
@end