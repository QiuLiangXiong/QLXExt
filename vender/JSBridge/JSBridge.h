//
//  JSBridge.h
//  JSBridge
//
//  Created by Peter on 15/7/2.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JSBridge : NSObject

@property (nonatomic, assign) id<UIWebViewDelegate> delegate;

/**
 *  初始化JSBridge
 *
 *  @param webView  需要桥接的webView
 *  @param delegate webView委托方法
 *
 *  @return
 */
- (id)initWithWebView:(UIWebView *)webView delegate:(id<UIWebViewDelegate>)delegate;

/**
 *  注册一个js处理
 *
 *  @param name     js对应的方法名
 *  @param target   native处理对象
 *  @param selector native对应的处理方法
 *
 *  @return YES:注册成功，NO:注册失败（可能是target不存在selector方法）
 */
- (BOOL)registerHandler:(NSString*)name target:(id)target selector:(SEL)selector;

@end

/*---------------------------使用举例----------------------------*/

/*
#import "ViewController.h"
#import "JSBridge.h"

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) JSBridge *bridge;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建webView，不要设置 webView.delegate
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
    // 创建JSBridge
    self.bridge = [[JSBridge alloc] initWithWebView:_webView delegate:self];
    
    // 注册js调用native端的方法
    [_bridge registerHandler:@"testObjcCallback" target:self selector:@selector(testObjcCallback:)];
    
    // 加载数据
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.fcuh.com/"]]];
}

- (id)testObjcCallback:(id)data
{
    // 收到js传递过来的数据是一个NSDictionary或者NSString类型的数据
    // 使用时和js端协调好传递的数据是什么:字符串或json对象
    NSLog(@"收到数据:%@",[data description]);
    
    // 返回的数据必须是一个NSDictionary或者NSString类型的数据
    // 没有数据则返回nil,或则函数的返回类型设置 void
    return @"返回数据";
}
*/
