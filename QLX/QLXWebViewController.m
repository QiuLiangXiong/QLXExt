//
//  QLXWebViewController.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXWebViewController.h"
#import "QLXExt.h"
@interface QLXWebViewController()<QLXWebViewDelegate>
@property (nonatomic, strong) QLXWebView * webView;
@end

@implementation QLXWebViewController

-(instancetype)initWithUrl:(NSString *)url{
    self = [super init];
    if (self) {
        [self initConfigWithUrl:url];
    }
    return self;
}

-(void) initConfigWithUrl:(NSString* ) url{
    self.urlStr = url;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
}

-(void) configView{
    [self.view addSubview:self.webView];
    [self.webView constraintWithEdgeZero];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(goBack) image:@"nav_back" highImage:@"nav_back_on"];
    //[NavigationController h5NavigationBarStyle];
    //[self.navigationController setNeedsStatusBarAppearanceUpdate];
}

-(void)setUrlStr:(NSString *)urlStr{
    if ([_urlStr isEqualToString:urlStr] == false) {
        _urlStr = urlStr;
        [self.webView loadRequestWithUrlStr:_urlStr];
    }
}

-(QLXWebView *)webView{
    if (!_webView) {
        _webView = [QLXWebView new];
        _webView.webViewDelegate = self;
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)goBack{
    if([self.webView canGoBack])
    {
        [self.webView goBack];
    }else {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:true];
        }else {
            [self.navigationController dismissViewControllerAnimated:true completion:nil];
        }
    }
}

-(void)webView:(UIWebView *)webView forTitle:(NSString *)title{
    if (title.length > 0) {
        self.title = title;
    }
}

@end
