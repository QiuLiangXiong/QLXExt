//
//  QLXSegmentItemData.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/29.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "ReuseDataBase.h"

@interface QLXSegmentItemData : ReuseDataBase

@property (nonatomic, copy)  NSString * title;        //标题
@property (nonatomic, strong) UIColor * normalColor; 
@property (nonatomic, strong) UIColor * selectorColor;
@property (nonatomic, strong) UIFont * font;
@property (nonatomic, assign) CGFloat   titleSpace; // 标题间距

@end
