//
//  QLXHttpModel.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/20.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXHttpModel.h"
#import "PageBaseParam.h"
#import "PageBaseResult.h"
#import "QLXExt.h"
#import "QLXHttpRequest.h"
#import "QLXHttpRequestManager.h"
@interface QLXHttpModel()

@property (nonatomic, strong)  QLXHttpRequest * requestOperation;
@property(nonatomic , assign)  int currentPage;

@end

@implementation QLXHttpModel

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initConfigs];
    }
    return self;
}

-(void) initConfigs{
    self.modelType = HttpModelTypePlain;
    self.data = [NSMutableArray new];
}

#pragma mark - 子类重写
//必写
-(NSString *) requestURL{
    assert(0);
    return nil;
}

//可选重写
-(BaseParam *) requestParam{
    return [BaseParam param];
}
//可选重写
-(Class)  requestResultClass{
    return [BaseResult class];
}

//可选重写
-(NSString *) requestType{
    return @"POST";
}

// -------------分界线----------------
// 子类可继承
- (BOOL) requestDidFinishWithResult:(BaseResult *) result error:(NSError * ) error{
    if (error == nil) {
        if (self.modelType == HttpModelTypePage ) {
            if (self.currentPage == 0) {
                [self.data removeAllObjects];
            }
            self.currentPage++;
            [self requestFinishToAddData:result];
        }
        self.resultData = result;
    }
    self.error = error;
    return true;
}

-(void) requestFinishToAddData:(BaseResult *) result{
    PageBaseResult * pageResult = (PageBaseResult *)result;
    if ([pageResult isKindOfClass:[PageBaseResult class]]) {
        [self.data addObjectsFromArray:pageResult.list];
    }
}

//加载
-(void) requestToLoad{
    self.currentPage = 0;
    [self request];
}

//加载更多
-(void) requestToLoadMore{
    [self request];
}

//向服务器请求
-(void) requestToServerWithParam:(BaseParam *) param{
    NSString * url = [self requestURL];
    NSString * requestType = [self requestType];
    if (url) {
        kBlockWeakSelf;
        if (self.requesting) {
            [self.requestOperation cancel];
        }
        self.requesting = true;
        self.requestOperation = [[self getHttpRequestManager] requestWithType:requestType url:url params:param resultClass:[self requestResultClass] response:^(BaseResult *result, NSError *error) {
            // 失败
            if (error) {
                if (error.code == (long)-999) {
                }else {
                    weakSelf.requesting = false;
                    if ([weakSelf requestDidFinishWithResult:nil error:error]) {
                        [weakSelf requestFinishWithError:error];
                    }
                }
            // 成功
            }else {
                weakSelf.requesting = false;
                BaseResult * modifyResult = [self modifyRequestFinishDataWithResult:result];  // 默认不修改
                if ([weakSelf requestDidFinishWithResult:modifyResult error:nil]) {
                    [weakSelf requestFinishWithError:nil];
                }
            }
        }];
    }
}

-(QLXHttpRequestManager * ) getHttpRequestManager{
    Class cla = NSClassFromString(@"HttpRequestManager");
    if (cla) {
        return [cla getInstance];
    }
    return [QLXHttpRequestManager getInstance];
}


//请求
-(void) request{
    BaseParam * param = [self requestParam];
    if (self.modelType == HttpModelTypePage ) {
        assert([param isKindOfClass:[PageBaseParam class]]);// 需要继承 PageBaseParam 类
        PageBaseParam * pageParam = (PageBaseParam *) param;
        pageParam.page = self.currentPage + 1;
    }
    [self requestToServerWithParam:param];
}
// 执行代理方法
-(void) requestFinishWithError:(NSError *) error{
    if (self.responseClose) {
        if (self.modelType == HttpModelTypePage) {
            self.responseClose(self.data , [self isHaveMore] , error);
        }else {
            self.responseClose(self.resultData , [self isHaveMore] , error);
        }
    }
    if ([self.delegate respondsToSelector:@selector(requestDidFinishWithData:hasMore:error:)]) {
        if (self.modelType == HttpModelTypePage) {
            [self.delegate requestDidFinishWithData:self.data hasMore:[self isHaveMore] error:error];
        }else {
            [self.delegate requestDidFinishWithData:self.resultData hasMore:[self isHaveMore] error:error];
        }
        
    }
    if ([self.delegate respondsToSelector:@selector(model:requestDidFinishWithData:hasMore:error:)]) {
        if (self.modelType == HttpModelTypePage) {
            [self.delegate model:self requestDidFinishWithData:self.data hasMore:[self isHaveMore] error:error];
            
        }else {
            [self.delegate model:self requestDidFinishWithData:self.resultData hasMore:[self isHaveMore] error:error];
        }
    }
}

-(id) getDataWithIndex:(NSInteger) index{
    return [self.data objectAtIndex:index];
}

-(HttpModelType)requestModelType;{
    return _modelType;
}

-(HttpModelType)modelType{
    return [self requestModelType];
}

-(void)dealloc{
    if (self.requesting) {
        [self.requestOperation cancel];
    }
}

-(BaseResult *) modifyRequestFinishDataWithResult:(BaseResult *)result{
    return result;   // 默认不修改
}

-(BOOL) isHaveMore{
    if (self.resultData) {
        if (self.resultData.noMoreData) {
            return false;
        }
        if ([self.resultData isKindOfClass:[PageBaseResult class]]) {
            PageBaseResult * result = (PageBaseResult *)self.resultData;
            return (result.list.count > 0);
        }
        return true;
    }
    return false;
}
// 是否请求完毕
+(BOOL) isRequestDoneWithAllModel:(QLXHttpModel *)model , ...{
    BOOL result = true;
    va_list arguments;
    id eachObject;
    if (model) {
        va_start(arguments, model);
        if (model.isRequesting) {
            result = false;
        }
        while ((eachObject = va_arg(arguments, id))) {
            if ([eachObject isKindOfClass:[QLXHttpModel class]]) {
                QLXHttpModel * m = (QLXHttpModel *)eachObject;
                if (m.requesting) {
                    result = false;
                    break;
                }
            }
        }
        va_end(arguments);
    }
    return result;
}
// 获取error
+(NSError *) getErrorWithAllModel:(QLXHttpModel *)model , ...{
    NSError * error = nil;
    va_list arguments;
    id eachObject;
    
    if (model) {
        va_start(arguments, model);
        if (model.error) {
            error = model.error;
        }

        while ((eachObject = va_arg(arguments, id))) {
            if ([eachObject isKindOfClass:[QLXHttpModel class]]) {
                QLXHttpModel * m = (QLXHttpModel *)eachObject;
                if (m.error) {
                    error = m.error;
                    break;
                }
            }
        }
        va_end(arguments);
    }
    return error;
}

+(BOOL) isRequestDoneWithModels:(NSArray *)models {
    BOOL result = true;
    for (QLXHttpModel * model in models) {
        if ([model isKindOfClass:[QLXHttpModel class]]) {
            if (model.isRequesting) {
                result = false;
                break;
            }
        }
    }
    return result;
}


+(NSError *) getErrorWithModels:(NSArray *)models{
    NSError * result = nil;
    for (QLXHttpModel * model in models) {
        if ([model isKindOfClass:[QLXHttpModel class]]) {
            if (model.error) {
                result = model.error;
                break;
            }
        }
    }
    return result;
}

/**
 *  加载 带有结果回调闭包
 *
 *  @param responseBlock 数据请求回来了 会回调这个闭包
 */
-(void) requestToLoadWithReponseBlock:(HttpModelResponse) responseBlock{
    self.responseClose = responseBlock;
    [self requestToLoad];
}
/**
 * 加载更多
 */
/**
 *  加载更多 带有结果回调闭包
 *
 *  @param responseBlock 数据请求回来了 会回调这个闭包
 */
-(void) requestToLoadMoreWithReponseBlock:(HttpModelResponse) responseBlock{
    self.responseClose = responseBlock;
    [self requestToLoadMore];
}

@end

