
//
//  QLXStaticPageCellData.m
//  FunPoint
//
//  Created by QLX on 16/1/6.
//  Copyright © 2016年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXStaticPageCellData.h"
#import "QLXExt.h"

@implementation QLXStaticPageCellData

-(NSString *)reuseIdentifier{
    return @"QLXStaticPageCell";
}




-(UIView *)singlePageView{
    if (!_singlePageView && _controller) {
        self.singlePageView = [QLXView createWithBgColor:[UIColor clearColor]];
        [self.singlePageView addSubview:_controller.view];
        [_controller.view constraintWithEdgeZero];
    }
    return _singlePageView;
}



@end
