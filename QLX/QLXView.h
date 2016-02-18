//
//  QLXView.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/21.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLXView : UIView
@property (nonatomic, strong) UIView * topLine;
@property (nonatomic, strong) UIView * bottomLine;
@property (nonatomic, strong) UIView * leftLine;
@property (nonatomic, strong) UIView * rightLine;
@property (nonatomic, strong) UIView * wrapView;  // 中间层的view  内容和 self 隔着 一个wrap view
@property (nonatomic, strong) UIView * mask;  // 蒙版


+(QLXView *) create;

+(QLXView *) createWithBgColor:(UIColor *) color;


@end
