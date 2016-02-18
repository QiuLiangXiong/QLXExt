//
//  QLXWebView.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/2.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QLXWebViewDelegate;
@interface QLXWebView : UIWebView
@property (nonatomic, weak) id<QLXWebViewDelegate>  webViewDelegate;

+(instancetype) createWithUrlStr:(NSString *) urlStr;


-(void)loadRequestWithUrlStr:(NSString *) urlStr;
/**
 *  注册一个js处理
 *
 *  @param name     js对应的方法名
 *  @param target   native处理对象
 *  @param selector native对应的处理方法
 *
 *  @return YES:注册成功，NO:注册失败（可能是target不存在selector方法）
 */
-(BOOL)registerHandler:(NSString*)name target:(id)target selector:(SEL)selector;

@end

@protocol QLXWebViewDelegate <UIWebViewDelegate>
@optional
/**
 *  网页标题
 *
 *  @param webView webview
 *  @param title   获取到的网页标题
 */
-(void)webView:(QLXWebView *)webView forTitle:(NSString *)title;

/**
 *  网页URL
 *
 *  @param webView webview
 *  @param title   获取到的网页标题
 */
-(void)webView:(QLXWebView *)webView forUrl:(NSString *)url;

-(BOOL)canGobackWithWebView:(QLXWebView *) webView;

-(BOOL)canGoForwardWithWebView:(QLXWebView *) webView;

@end