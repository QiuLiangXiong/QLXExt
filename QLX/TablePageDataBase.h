//
//  TablePageDataBase.h
//  QLXExtDemo
//
//  Created by QLX on 15/10/31.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "ReuseDataBase.h"

// 这些数据要就可以显示一个tableview 数据驱动view 的思想 根据reuseIndentifer 来 自动配置对应的view
@interface TablePageDataBase : ReuseDataBase

@property (nonatomic, strong) NSMutableArray * cellDataList;  // cell数据
@property (nonatomic, strong) NSMutableArray * headerDataList;// 头部数据
@property (nonatomic, strong) NSMutableArray * footerDataList;// 尾部数据

// 记录滚动位置  这个不需要自己控制
@property(nonatomic , assign) CGFloat offsetY;  // 0 代表还有更多

// -1代表加载错误
// 1 没有更多
//  如需扩展跟多状态 请继承QLXTableViewPage 自定义
@property(nonatomic , assign) NSInteger state;

@end
