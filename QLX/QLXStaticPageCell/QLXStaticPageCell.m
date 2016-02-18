//
//  QLXStaticPageCell.m
//  FunPoint
//
//  Created by QLX on 16/1/6.
//  Copyright © 2016年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXStaticPageCell.h"
#import "QLXStaticPageCellData.h"
#import "QLXExt.h"

@implementation QLXStaticPageCell


-(void)reuseWithData:(ReuseDataBase *)data indexPath:(NSIndexPath *)indexPath{
    [super reuseWithData:data indexPath:indexPath];
    QLXStaticPageCellData * rData = (QLXStaticPageCellData *)data;
    [self.view removeAllSubivews];
    if( rData.singlePageView.superview) {
       [rData.singlePageView removeFromSuperview];
    }
    rData.singlePageView.frame = CGRectMake(0, 0, rData.width, rData.height);
    [self.view addSubview:rData.singlePageView];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    //  清空子视图
    [self.view removeAllSubivews];
}



@end
