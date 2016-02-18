//
//  QLXHttpModel.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/20.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResult.h"
#import "BaseParam.h"

typedef void (^HttpModelResponse)(id data , BOOL more , NSError * error);

@class QLXHttpRequestManager;


typedef  enum{
    HttpModelTypePage,  // 分页数据类型
    HttpModelTypePlain  // 普通类型
}HttpModelType;
@protocol  QLXHttpModelDelegate;

@interface QLXHttpModel : NSObject

@property (nonatomic, assign) HttpModelType modelType;
@property (nonatomic, strong) NSMutableArray * data;            //数据
@property (nonatomic, weak) id<QLXHttpModelDelegate> delegate;
@property (nonatomic, strong) BaseResult * resultData;
@property (nonatomic, assign,getter=isRequesting) BOOL requesting;
@property (nonatomic, strong) NSError * error;
@property(nonatomic , copy) HttpModelResponse responseClose;
/**
 * 初始化 可被继承
 */
-(void) initConfigs;
/**
 * 加载
 */
-(void) requestToLoad;

/**
 *  加载 带有结果回调闭包
 *
 *  @param responseBlock 数据请求回来了 会回调这个闭包
 */
-(void) requestToLoadWithReponseBlock:(HttpModelResponse) responseBlock;
/**
 * 加载更多
 */
-(void) requestToLoadMore;
/**
 * 加载更多
 */
/**
 *  加载更多 带有结果回调闭包
 *
 *  @param responseBlock 数据请求回来了 会回调这个闭包
 */
-(void) requestToLoadMoreWithReponseBlock:(HttpModelResponse) responseBlock;

/**
 * 请求链接
 * 一定重写
 */
-(NSString *) requestURL;
/**
 * 请求参数
 * 可重写
 */
-(BaseParam *) requestParam;

/**
 *  和请求参数对应 用于请求回来数据字典转模型对应的模型类
 *  结果类型
 *  @return 类型
 */
-(Class)  requestResultClass;
/**
 * 请求方式  "GET" 和 "POST" 两种
 * 可重写
 * 默认 "POST"
 */
-(NSString *) requestType;

/**
 *  model 类型  分页  和 普通两种 默认为分页
 *
 *  @return
 */
-(HttpModelType)requestModelType;

/**
 *  可重写网络请求单例
 *
 *  @return 返回单例对象
 */
-(QLXHttpRequestManager * ) getHttpRequestManager;

/**
 *  可以重写 判断是否还有更多数据  用于分页数据返回判断 是否有更多
 *
 *  @return
 */
-(BOOL) isHaveMore;
/**
 *  请求数据完成回调
 *
 *  @param result 返回数据
 *  @param error  错误信息
 *
 *  @return 是否发送请求数据完成代理
 */
- (BOOL) requestDidFinishWithResult:(BaseResult *) result error:(NSError * ) error;
/**
 *  执行代理  通知 代理
 *
 *  @param error 错误信息
 */
-(void) requestFinishWithError:(NSError *) error;
/**
 *  分页数据 获取
 *
 *  @param index 第几个
 *
 *  @return 该条数据
 */
-(id) getDataWithIndex:(NSInteger) index;


/**
 *  数据请求回来  要添加到数组的时候回调
 *
 *  @param result
 */
-(void) requestFinishToAddData:(BaseResult *) result;

/**
 *  对于服务器传来的数据 可以自己进行修改后在当做服务器的数据  一般用于产生测试数据
 *
 *  @param result
 *
 *  @return 默认不修改
 */
-(BaseResult *) modifyRequestFinishDataWithResult:(BaseResult *)result;

// 是否请求完毕
+(BOOL) isRequestDoneWithAllModel:(QLXHttpModel *)model , ... NS_REQUIRES_NIL_TERMINATION ;
+(BOOL) isRequestDoneWithModels:(NSArray *)models ;


// 获取error
+(NSError *) getErrorWithAllModel:(QLXHttpModel *)model , ... NS_REQUIRES_NIL_TERMINATION;
+(NSError *) getErrorWithModels:(NSArray *)models;



@end

@protocol QLXHttpModelDelegate <NSObject>

@optional
/**
 *  //请求完成 回调
 *
 *  @param data  请求返回数据
 *  @param more  是否还有更多数据（对于分页数据来说）
 *  @param error 返回的错误信息 如果是有  则为请求失败
 */
-(void) requestDidFinishWithData:(id) data hasMore:(BOOL) more error:(NSError *) error;

-(void) model:(QLXHttpModel *)model requestDidFinishWithData:(id) data hasMore:(BOOL) more error:(NSError *) error;

@end
