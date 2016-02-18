//
//  QLXNoviceGuideBaseView.h
//  新手引导  的 基类
//
//  Created by QLX on 16/1/23.
//  Copyright © 2016年 avatar. All rights reserved.
//

#import "QLXView.h"

@interface QLXNoviceGuideBaseView : QLXView

/**
 *  该方法显示 引导页面
 *
 *  @param view 在这里下显示
 *  @param key  判断是否是第一次显示的根据
 */

+(void) showInView:(UIView *) view key:(NSString *) key;

@end
