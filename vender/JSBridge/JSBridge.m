//
//  JSBridge.m
//  JSBridge
//
//  Created by Peter on 15/7/2.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "JSBridge.h"
#import "WebViewJavascriptBridge.h"
#import "JSHandler.h"

@interface JSBridge()<UIWebViewDelegate>

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSMutableDictionary *jsHanlders;

@end

@implementation JSBridge

- (id)initWithWebView:(UIWebView *)webView delegate:(id<UIWebViewDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        
        self.webView = webView;
        
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(NSString *handlerName, id data, WVJBResponseCallback responseCallback) {
            // Do nothing
        }];
        
        self.jsHanlders = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (BOOL)registerHandler:(NSString*)name target:(id)target selector:(SEL)selector
{
    BOOL registered = NO;
    
    JSHandler *jsHandler =  [JSHandler jsHandlerWithName:name target:target selector:selector];
    
    if (jsHandler)
    {
        [_jsHanlders setObject:jsHandler forKey:jsHandler.name];
        
        [_bridge registerHandler:name handler:^(NSString *handlerName, id data, WVJBResponseCallback responseCallback) {
            
            JSHandler *hander = [_jsHanlders objectForKey:handlerName];
            
            if (hander != nil)
            {
                [self callHandler:hander data:data callBack:responseCallback];
            }
            
        }];
        
        registered = YES;
    }
    
    
    return registered;
}

#pragma mark - 

- (void)initJSBridge
{
    NSString *jsBridgeObjectStr = [self jsStringOfJSBridgeObject];
    
    NSString* jsInterfaces = [self jsStringOfAllJSInterfaces];
    
    NSString* initJSBridgeJavascript = [NSString stringWithFormat:@"%@%@",jsBridgeObjectStr,jsInterfaces];
    
    [_webView stringByEvaluatingJavaScriptFromString:initJSBridgeJavascript];
    
    [_webView stringByEvaluatingJavaScriptFromString:[self jsBridgeEvent]];
    
}

- (NSString *)jsBridgeEvent
{
    static NSString *jsBridgeEvent = @"(function(){if(window.jsBridgeEventDispatched == undefined && window.jsBridge != undefined){var readyEvent = document.createEvent('Events');readyEvent.initEvent('JSBridgeReady');readyEvent.bridge = jsBridge;window.dispatchEvent(readyEvent); window.jsBridgeEventDispatched=1;}})();";
    
    return jsBridgeEvent;
}

- (NSString *)jsStringOfJSBridgeObject
{
    
    static NSString* jsObjectStr = @"(function(){if (window.jsBridge == undefined) { window.jsBridge = new Object();}})();";
    
    return jsObjectStr;
}

- (NSString*)jsStringOfAllJSInterfaces
{
    NSMutableString* jsInterfacesStr = [NSMutableString stringWithString:@"(function(){"];
    
    NSArray* jsHandlers = [self.jsHanlders allValues];
    
    for(JSHandler* handler in jsHandlers)
    {
        if (handler)
        {
            [jsInterfacesStr appendString:[self jsStringOfJSInterfaceForHandler:handler]];
        }
    }

    [jsInterfacesStr appendString:@"})();"];
    
    return jsInterfacesStr;
}

- (NSString *)jsStringOfJSInterfaceForHandler:(JSHandler *)handler
{
    NSString* name = handler.name;
    id target = handler.target;
    SEL selector = handler.selector;
    
    NSMutableString* jsInterfaceStr = [NSMutableString stringWithFormat:@"if (window.jsBridge.%@ == undefined) {", name];
    
    NSMethodSignature * sig = [[target class] instanceMethodSignatureForSelector: selector];
    
    BOOL hasReturnValue = [sig methodReturnLength] > 0 ? YES : NO;
    
    NSMutableString* jsFunctionHeader = [NSMutableString stringWithFormat:@"function (data"];
    
    if (hasReturnValue)
    {
        [jsFunctionHeader appendString:@",respCallback"];
    }
    
    [jsFunctionHeader appendString:@")"];
    
    NSString* jsFunctionBody = nil;
    if (hasReturnValue)
    {
        jsFunctionBody = [NSString stringWithFormat:@"{WebViewJavascriptBridge.callHandler('%@', data, respCallback);}", name];
    }
    else
    {
        jsFunctionBody = [NSString stringWithFormat:@"{WebViewJavascriptBridge.callHandler('%@',data, null);}", name];
    }
    
    NSString* jsFunctionDef = [jsFunctionHeader stringByAppendingString: jsFunctionBody];
    [jsInterfaceStr appendFormat:@"window.jsBridge.%@ = %@;",name, jsFunctionDef];
    [jsInterfaceStr appendString:@"}"];
    
    return jsInterfaceStr;
}

- (void)callHandler:(JSHandler*)handler data:(id)data callBack:(WVJBResponseCallback)cb
{
    
    id target =  handler.target;
    if (target)
    {
        SEL selector = handler.selector;
        
        NSMethodSignature * sig = [[target class]
                                   instanceMethodSignatureForSelector:selector];
        
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget: target];
        [invocation setSelector: selector];
        
        if ([data isKindOfClass:[NSString class]] || [data isKindOfClass:[NSDictionary class]])
        {
            [invocation setArgument: &data atIndex: 2];
        }
        
        [invocation retainArguments];
        [invocation invoke];
        
        const char* methodReturnType = [[invocation methodSignature] methodReturnType];
        
        if(!strcmp(methodReturnType, @encode(void)))
        {
            cb(@"");
        }
        else if (!strcmp(methodReturnType, @encode(id)))
        {
            id returnValue = nil;
            [invocation getReturnValue:&returnValue];
            
            cb(returnValue);
        }
        else
        {
            // Do nothing
        }
    }
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
    {
        return [_delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_delegate webViewDidStartLoad:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_delegate webView:webView didFailLoadWithError:error];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self initJSBridge];
    
    [_delegate webViewDidFinishLoad:webView];
}

@end

