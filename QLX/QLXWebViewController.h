//
//  QLXWebViewController.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXViewController.h"

@interface QLXWebViewController : QLXViewController
@property (nonatomic, copy) NSString * urlStr;

/**
 *  初始化
 *
 *  @param url 链接 字符串
 *
 *  @return 实例
 */
-(instancetype)initWithUrl:(NSString *)url;
@end
