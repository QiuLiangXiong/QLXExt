//
//  QLXHttpRequestManager.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/12/1.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLXHttpRequest.h"
#import "QLXExt.h"

typedef void (^HttpCompletion) (BaseResult * result , NSError * error);

@interface QLXHttpRequestManager : NSObject

@property(nonatomic , copy) NSString * rootURL;   //  url 的 前缀  比如 服务器域名 本地就是http://localhost:8888/

singleInstanceDefine   // 单例 宏定义 声明

//  请求接口   type 有两种值  "POST" 和 “GET”
-(QLXHttpRequest *) requestWithType:(NSString *)type url:(NSString *)url params:(BaseParam *)params resultClass:(Class) resultClass response:(HttpCompletion) complete;

//  get 请求接口
-(QLXHttpRequest *) requestForGetWithUrl:(NSString *)url params:(BaseParam *)params resultClass:(Class) resultClass response:(HttpCompletion) complete;

// post 请求接口
-(QLXHttpRequest *) requestForPostWithUrl:(NSString *)url params:(BaseParam *)params resultClass:(Class) resultClass response:(HttpCompletion) complete;
// 上传
-(QLXHttpRequest *) uploadWithUrl:(NSString *) url filePath:(NSString *)path params:(BaseParam *)params resultClass:(Class) resultClass progress:(HttpProgress) progress completion:(HttpCompletion) completion;
// 下载
-(QLXHttpRequest *) downloadWithUrl:(NSString *) url filePath:(NSString *)path params:(BaseParam *)params progress:(HttpProgress) progress completion:(HttpResponse) completion;

/**
 *  可重写 数据请求回来了处理data 返回相应的字典对象result
 *
 *  @param data        接口返回 字典数据
 *  @param resultClass 字典转模型 对应 的 类型
 *
 *  @return 字典转后的模型 对象
 */
-(BaseResult *) getResultWithResponseData:(id) data resultClass:(Class) resultClass;

/**
 *  可重写 根据返回的错误进行二次处理
 *
 *  @param error 原始错误
 *
 *  @return 处理过的 错误
 */
-(NSError * ) getErrorWithRawError:(NSError *)error;


/**
 *  可重写 根据模型转字典
 *
 *  @param params 模型对象
 *
 *  @return 生成对应的字典
 */
-(NSDictionary *)  getParamDictionaryWithParams:(BaseParam *)params;



@end
