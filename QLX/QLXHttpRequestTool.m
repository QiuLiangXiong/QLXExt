//
//  QLXHttpRequestTool.m
//  FunPoint
//
//  Created by QLX on 15/12/20.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXHttpRequestTool.h"
#import "AFNetWorking.h"
#import <Foundation/NSObject.h>
#import "QLXHttpRequest.h"

@implementation QLXHttpRequestTool

+(QLXHttpRequest *)  requestForGetWithUrl:(NSString *) url params:(NSDictionary *)params response:(HttpResponse) complete{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if (complete) {
                complete(nil , error);
            }
        } else {
            if (complete) {
                complete(responseObject , nil);
            }
        }
    }];
    [dataTask resume];
    return [[QLXHttpRequest alloc] initWithTask:dataTask];
}

+(QLXHttpRequest *)  requestForPostWithUrl:(NSString *) url params:(NSDictionary *)params response:(HttpResponse) complete{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if (complete) {
                complete(nil , error);
            }
        } else {
            if (complete) {
                complete(responseObject , nil);
            }
        }
    }];
    [dataTask resume];
    return [[QLXHttpRequest alloc] initWithTask:dataTask];
}

+(QLXHttpRequest *) uploadWithUrl:(NSString *) url filePath:(NSString *)path params:(NSDictionary *)params progress:(HttpProgress) progress completion:(HttpResponse) completion{
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          if (progress) {
                              progress(uploadProgress.fractionCompleted);
                          }
                         // [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          if (completion) {
                              completion(nil , error);
                          }
                      } else {
                          if (completion) {
                              completion(responseObject , nil);
                          }
                      }
                  }];
    [uploadTask resume];
    return [[QLXHttpRequest alloc] initWithTask:uploadTask];
}

+(QLXHttpRequest *) downloadWithUrl:(NSString *) url filePath:(NSString *)path params:(NSDictionary *)params progress:(HttpProgress) progress completion:(HttpResponse) completion{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:nil error:nil];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update the progress view
            if (progress) {
                progress(downloadProgress.fractionCompleted);
            }
            // [progressView setProgress:uploadProgress.fractionCompleted];
        });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        if ([path containsString:@"."] == false) { // 看来 是个目录  那就帮他添加文件名
            NSString * newPath = [path stringByAppendingPathComponent:[response suggestedFilename]];
            return [NSURL fileURLWithPath:newPath];;//
        }
        return   [NSURL fileURLWithPath:path];;// 下载到本地的路径
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil , error);
            }
        } else {
            if (completion) {
                NSString * path = filePath.absoluteString;
                if ([path hasPrefix:@"file://"]) {
                    path = [path substringFromIndex:7];
                }
                completion(path , nil);
            }
        }    }];
    [downloadTask resume];
    
    return [[QLXHttpRequest alloc] initWithTask:downloadTask];
}




@end
