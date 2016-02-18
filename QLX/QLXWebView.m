//
//  QLXWebView.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/2.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXWebView.h"
#import "QLXExt.h"
#import "JSBridge.h"
#import "WebViewJavascriptBridge.h"
#import "YXGCD.h"
@interface QLXWebView()<UIWebViewDelegate>
@property (nonatomic, strong) JSBridge *bridge;
@property (nonatomic, strong) UIProgressView * loadProgress;
@property (nonatomic, weak) id<UIWebViewDelegate> jsBridgeDelegate;
@property (nonatomic, strong) CADisplayLink * loadProgressTimer;
@end
@implementation QLXWebView
+(instancetype) createWithUrlStr:(NSString *) urlStr{
    QLXWebView * instance = [self new];
    [instance loadRequestWithUrlStr:urlStr];
    return instance;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initConfigs];
    }
    return self;
}



-(void)initConfigs{
    self.delegate = self;
    [self.loadProgress mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(@3);
    }];
}

-(JSBridge *)bridge{
    if (!_bridge) {
        _bridge = [[JSBridge alloc] initWithWebView:self  delegate:self];
    }
    return _bridge;
}

-(UIProgressView *)loadProgress{
    if (!_loadProgress) {
        _loadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _loadProgress.progressTintColor = [UIColor colorWithHexString:@"#ff9900"];
        _loadProgress.trackTintColor = [UIColor clearColor];
        [self addSubview:_loadProgress];
    }
    return _loadProgress;
}

-(void)loadRequestWithUrlStr:(NSString *) urlStr{
    NSURL * url = [NSURL URLWithString:urlStr];
    
    [self loadRequest:[NSURLRequest requestWithURL:url cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:30]];
}

-(BOOL)registerHandler:(NSString*)name target:(id)target selector:(SEL)selector{
    return [self.bridge registerHandler:name target:target selector:selector];
}

- (void)stopProgressTimer
{
    [self.loadProgressTimer invalidate];
    self.loadProgressTimer= nil;
}

-(void) loadProgressUpdate{
    CGFloat progress = self.loadProgress.progress ;
    progress += 0.002;
    if (progress > 0.95) {
        progress = 0.95;
    }
    [self.loadProgress setProgress:progress animated:true];
    self.loadProgress.hidden = progress < 0.05;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    BOOL result = true;
    if ([self.webViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        result = [self.webViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    if ([self.jsBridgeDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        result =  [self.jsBridgeDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return result;
}

-(void)onExit{
    [self stopProgressTimer];
    [self stopLoading];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    if ([self.webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.webViewDelegate webViewDidStartLoad:webView];
    }
    if ([self.jsBridgeDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.jsBridgeDelegate webViewDidStartLoad:webView];
    }
    [self startTimer];
}

-(void)startTimer{
    if ([self isLoading]) {
        [self stopProgressTimer];
        [self.loadProgress setProgress:0.00 animated:false];
        self.loadProgressTimer =
        [CADisplayLink displayLinkWithTarget:self selector:@selector(loadProgressUpdate)];
        [self.loadProgressTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([self.webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webViewDelegate webViewDidFinishLoad:webView];
    }
    if ([self.jsBridgeDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.jsBridgeDelegate webViewDidFinishLoad:webView];
    }
    [self stopProgressTimer];
    [self.loadProgress setProgress:1 animated:false];
    [GCDQueue executeInMainQueue:^{
        self.loadProgress.progress = 0;
    } afterDelaySecs:0.5];
    
    NSString * title = [self stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([self.webViewDelegate respondsToSelector:@selector(webView:forTitle:)]) {
        [self.webViewDelegate webView:(QLXWebView *)webView forTitle:title];
    }
    
    NSString * curUrl = [self stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
    if ([self.webViewDelegate respondsToSelector:@selector(webView:forUrl:)]) {
        [self.webViewDelegate webView:(QLXWebView *)webView forUrl:curUrl];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ([self.webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webViewDelegate webView:webView didFailLoadWithError:error];
    }
    if ([self.jsBridgeDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.jsBridgeDelegate webView:webView didFailLoadWithError:error];
    }
    [self stopProgressTimer];
    [self.loadProgress setProgress:0 animated:false];
}

-(void)setDelegate:(id<UIWebViewDelegate>)delegate{
    if (((id)delegate) != self) {
        if ([delegate isKindOfClass:[WebViewJavascriptBridge class]]) {
            self.jsBridgeDelegate = delegate;
        }else {
            self.webViewDelegate = (id<QLXWebViewDelegate>)delegate;
        }
    }else {
        [super setDelegate:delegate];
    }
}

-(BOOL)canGoBack{
    BOOL can = [super canGoBack];
    if ([self.webViewDelegate respondsToSelector:@selector(canGobackWithWebView:)]) {
        can = [self.webViewDelegate canGobackWithWebView:self];
    }
    return can;
}

-(BOOL)canGoForward{
    BOOL can = [super canGoForward];
    if ([self.webViewDelegate respondsToSelector:@selector(canGoForwardWithWebView:)]) {
        can = [self.webViewDelegate canGoForwardWithWebView:self];
    }
    return can;

}





@end
