//
//  QLXHttpController.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/11/9.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXHttpController.h"
#import "QLXExt.h"

@interface QLXHttpController ()




@end



@implementation QLXHttpController

@synthesize noneDataView    = _noneDataView;
@synthesize noneNetWorkView = _noneNetWorkView;
@synthesize firstLoadingView = _firstLoadingView;
@synthesize requestErrorView = _requestErrorView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) showFirstLoadingView{
    if (self.firstLoadingView) {
        [self.view hideSubViews];
        self.firstLoadingView.hidden = false;
    }
    
}

-(void) showNoneDataView{
    if (self.noneDataView) {
        [self.view hideSubViews];
        self.noneDataView.hidden = false;
    }
}

-(void) showNoneNetWorkView{
    if (self.noneNetWorkView) {
        [self.view hideSubViews];
        self.noneNetWorkView.hidden = false;
    }
    
}

-(void) showRequestErrorView{
    if (self.requestErrorView) {
        [self.view hideSubViews];
        self.requestErrorView.hidden = false;
    }
    
}

-(void) showMainView{
    [self.view showSubViews];
    self.firstLoadingView.hidden = true;
    self.noneNetWorkView.hidden = true;
    self.requestErrorView.hidden = true;
    self.noneDataView.hidden = true;
}

//无数据页面
-(UIView *)noneDataView{
    if (!_noneDataView) {
        _noneDataView = [self getNoneDataView];
        _noneDataView.hidden = true;
    }
    if (_noneDataView) {
        if (_noneDataView.superview == nil) {
            
            [self.view addSubview:_noneDataView];
            [_noneDataView constraintWithEdgeZero];
        }
    }
    return _noneDataView;
}

-(void)setNoneDataView:(UIView *)noneDataView{
    _noneDataView = noneDataView;
    _noneDataView.hidden = true;
}


// 无网络页面
-(UIView *)noneNetWorkView{
    if (!_noneNetWorkView) {
        _noneNetWorkView = [self getNoneNetWorkView];
        _noneNetWorkView.hidden = true;
    }
    if (_noneNetWorkView) {
        if (_noneNetWorkView.superview == nil) {
            
            [self.view addSubview:_noneNetWorkView];
            
            [_noneNetWorkView constraintWithEdgeZero];
        }
    }
    return _noneNetWorkView;
}

-(void) setNoneNetWorkView:(UIView *)noneNetWorkView{
    _noneNetWorkView = noneNetWorkView;
    _noneNetWorkView.hidden = true;
}
//第一次加载页面
-(UIView *)firstLoadingView{
    if (!_firstLoadingView) {
        _firstLoadingView = [self getFirstLoadingView];
        _firstLoadingView.hidden = true;
    }
    if (_firstLoadingView) {
        if (_firstLoadingView.superview == nil) {
            [self.view addSubview:_firstLoadingView];
            [_firstLoadingView constraintWithEdgeZero];
        }
    }
    return _firstLoadingView;
}


// 请求错误页面
-(UIView *)requestErrorView{
    if (!_requestErrorView) {
        _requestErrorView = [self getRequestErrorView];
        _requestErrorView.hidden = true;
    }
    if (_requestErrorView) {
        if (_requestErrorView.superview == nil) {
            
            [self.view addSubview:_requestErrorView];
            [_requestErrorView constraintWithEdgeZero];
        }
    }
    return _requestErrorView;
}


-(UIView *) getFirstLoadingView{
    return nil;
}

-(UIView *) getRequestErrorView{
    return  nil;
}

-(UIView *)getNoneDataView{
    return  nil;
}

-(UIView *)getNoneNetWorkView{
    return nil;
    
}


@end
