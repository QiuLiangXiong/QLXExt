//
//  PageBaseResult.h
//  fcuhConsumer
//
//  Created by Peter on 15/8/13.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "BaseResult.h"

@interface PageBaseResult : BaseResult

//total	int	数据总条数
//pageCount	int	总分页数
//--list--	array	数据列表
@property (nonatomic, assign) int totalCount;               //数据总条数
@property (nonatomic, assign) int pageCount;                //总分页数
@property (nonatomic, assign) int page;                     //页数
@property (nonatomic, strong) NSMutableArray *list;                //数据列表

@end
