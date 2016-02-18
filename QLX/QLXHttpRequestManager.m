//
//  QLXHttpRequestManager.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/12/1.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXHttpRequestManager.h"
#import "MJExtension.h"
#import "QLXHttpRequestTool.h"


@implementation QLXHttpRequestManager

singleInstanceImple

-(QLXHttpRequest *) requestWithType:(NSString *)type url:(NSString *)url params:(BaseParam *)params resultClass:(Class) resultClass response:(HttpCompletion) complete{
    NSString * requestType = [type lowercaseString];
    if ([requestType isEqualToString:@"get"]) {
      return [self requestForGetWithUrl:url params:params resultClass:resultClass response:complete];
    }else {
      return [self requestForPostWithUrl:url params:params resultClass:resultClass response:complete];
    }
}

-(QLXHttpRequest *) requestForGetWithUrl:(NSString *)url params:(BaseParam *)params resultClass:(Class) resultClass response:(HttpCompletion) complete{
    NSDictionary * parmsDic = [self getParamDictionaryWithParams:params];
    NSString * urlStr = [self getAbsoluteUrlWithUrl:url];
    
    return  [QLXHttpRequestTool requestForGetWithUrl:urlStr params:parmsDic response:^(id data, NSError *error) {
        if (!error) {
            BaseResult * resultObj = [self getResultWithResponseData:data resultClass:resultClass];
            if (complete) {
                complete(resultObj , nil);
            }
        }else {
            error = [self getErrorWithRawError:error];
            if (complete)  {
                complete(nil , error);
            }
        }
    }];
}

-(QLXHttpRequest *) requestForPostWithUrl:(NSString *)url params:(BaseParam *)params resultClass:(Class) resultClass response:(HttpCompletion) complete{
    NSDictionary * parmsDic = [self getParamDictionaryWithParams:params];
    NSString * urlStr = [self getAbsoluteUrlWithUrl:url];
    
    return  [QLXHttpRequestTool requestForPostWithUrl:urlStr params:parmsDic response:^(id data, NSError *error) {
        if (!error) {
            BaseResult * resultObj = [self getResultWithResponseData:data resultClass:resultClass];
            if (complete) {
                complete(resultObj , nil);
            }
        }else {
            error = [self getErrorWithRawError:error];
            if (complete)  {
                complete(nil , error);
            }
        }
    }];
}

-(QLXHttpRequest *) uploadWithUrl:(NSString *) url filePath:(NSString *)path params:(BaseParam *)params resultClass:(Class) resultClass progress:(HttpProgress) progress completion:(HttpCompletion) completion{
    NSDictionary * parmsDic = [self getParamDictionaryWithParams:params];
    NSString * urlStr = [self getAbsoluteUrlWithUrl:url];
    return  [QLXHttpRequestTool uploadWithUrl:urlStr filePath:path params:parmsDic progress:progress completion:^ (id data, NSError *error) {
         if (!error) {
             BaseResult * resultObj = [self getResultWithResponseData:data resultClass:resultClass];
             if (completion) {
                 completion(resultObj , nil);
             }
         }else {
             error = [self getErrorWithRawError:error];
             if (completion)  {
                 completion(nil , error);
             }
         }
     }];
}

-(QLXHttpRequest *) downloadWithUrl:(NSString *) url filePath:(NSString *)path params:(BaseParam *)params progress:(HttpProgress) progress completion:(HttpResponse) completion{
    NSDictionary * parmsDic = [self getParamDictionaryWithParams:params];
    NSString * urlStr = [self getAbsoluteUrlWithUrl:url];
    return [QLXHttpRequestTool downloadWithUrl:urlStr filePath:path params:parmsDic progress:progress completion:completion];
}

-(NSString *) getAbsoluteUrlWithUrl:(NSString *)url{
    if (![url hasPrefix:@"http"] && self.rootURL) {
        return [self.rootURL stringByAppendingPathComponent:url];
    }
    return url;
}


-(BaseResult *) getResultWithResponseData:(id) data resultClass:(Class) resultClass{
    if ([data isKindOfClass:[NSDictionary class]] && resultClass) {
        NSDictionary * resultDic = (NSDictionary *)data;
        return [resultClass mj_objectWithKeyValues:resultDic];
    }
    return nil;
}

-(NSError * ) getErrorWithRawError:(NSError *)error{
    return error;
}


-(NSDictionary *)  getParamDictionaryWithParams:(BaseParam *)params{
    return [params mj_keyValues];
}

@end
