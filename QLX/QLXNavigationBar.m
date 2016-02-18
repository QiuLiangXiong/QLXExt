//
//  QLXNavigationBar.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/24.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXNavigationBar.h"
#import "QLXExt.h"
@interface QLXNavigationBar()
@property (nonatomic, assign) double lastTimestamp;
@property (nonatomic, assign) CGPoint firstPoint;

@end


@implementation QLXNavigationBar

-(void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics{
    self.bgImage = backgroundImage;
    [super setBackgroundImage:backgroundImage forBarMetrics:barMetrics];
}
-(void)setBackgroundImage:(UIImage *)backgroundImage forBarPosition:(UIBarPosition)barPosition barMetrics:(UIBarMetrics)barMetrics{
    self.bgImage = backgroundImage;
    [super setBackgroundImage:backgroundImage forBarPosition:barPosition barMetrics:barMetrics];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIButton *button in self.subviews) {
        //发现不是我们添加进去的Button就结束此次循环
        if (![button isKindOfClass:[UIButton class]]) continue;
        
        //调整按钮位置
        if (button.centerX < self.width * 0.5) { // 左边的按钮
            button.x = 8;
        } else if (button.centerX > self.width * 0.5) { // 右边的按钮
            button.x = self.width - button.width-8;
        }
    }
}

/**
 *  每次触摸 该函数被调用多次 而 该导航栏 多次调用的point 除了第一个点是正确的
 *  我们现在只取 每次触摸 连续回调中的第一个正确的点（）
 *  @return 是否在区域内
 */
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.lastTimestamp != event.timestamp) {
        self.lastTimestamp = event.timestamp;
        self.firstPoint = point;
    }
    return [super pointInside:self.firstPoint withEvent:event];
}






@end
