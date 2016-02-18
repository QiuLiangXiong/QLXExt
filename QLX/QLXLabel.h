//
//  QLXLabel.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/17.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+QLXExt.h"
@interface QLXLabel : UILabel

@property (nonatomic, assign) BOOL staticEnable; // 是否为静态 label
@property (nonatomic, assign) CGFloat lineSpace;  // 行间距
@property (nonatomic, assign) CGFloat paragraphSpace; // 段距



-(void) adjustLineSpacing;

-(void) setTextColor:(UIColor *)textColor range:(NSRange)range;


@end
