//
//  QLXPageAnimator.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/11/20.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , QLXPageDirection) {
    QLXPageDirectionVertical,   // 纵向翻页  默认
    QLXPageDirectionHoriztion   // 横向翻页
};

@protocol QLXPageAnimatorDelegate ;

@interface QLXPageAnimator : NSObject

@property (nonatomic, weak) UIView * targetView;
@property (nonatomic, weak) id<QLXPageAnimatorDelegate> delegate;
@property (nonatomic, assign) QLXPageDirection  direction;
@property (nonatomic, assign) CGFloat maxProgressWhenNone;  // 没有下一页或者没有上一页的时候 滑动的最大百分比 默认0.4

+(instancetype) createWithTargetView:(UIView *) targetView;

@end


@protocol QLXPageAnimatorDelegate <NSObject>

@required

-(BOOL)  toNextPageWithPageAnimator:(QLXPageAnimator *)animator;
-(BOOL)  toLastPageWithPageAnimator:(QLXPageAnimator *)animator;


@end
