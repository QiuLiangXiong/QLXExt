//
//  QLXCollectionViewController.h
//  fcuhConsumer
//
//  Created by QLX on 16/1/22.
//  Copyright © 2016年 avatar. All rights reserved.
//

#import "QLXHttpController.h"
#import "QLXCollectionView.h"
#import "QLXHttpModel.h"

@interface QLXCollectionViewController : QLXHttpController<QLXHttpModelDelegate , QLXCollectionViewDelegate , QLXCollectionViewDataSourceDelegate , UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) BOOL firstRefreshEnable;  //是否允许第一次刷新
@property (nonatomic, assign) BOOL firstFefreshing;
@property (nonatomic, strong) QLXCollectionView * collectionView;
@property (nonatomic, strong) QLXHttpModel * aModel;

/**
 *  首次刷新 可以重复调用
 */
-(void) firstRefresh;

// 布局类  可重写
-(UICollectionViewLayout *) getCollectionViewLayout;

//可重写

-(QLXHttpModel *) getModel;


//数据请求完毕后  处理必要的逻辑 可重写
-(BOOL) requestFinishLogicWithData:(id)data  error:(NSError *) error;




@end
