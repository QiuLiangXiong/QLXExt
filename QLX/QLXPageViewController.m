//
//  QLXPageViewController.m
//  FunPoint
//
//  Created by QLX on 16/1/10.
//  Copyright © 2016年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXPageViewController.h"
#import "QLXExt.h"

// 矩形位置关系  注： 这里不考虑相切的情况
typedef enum {
    RectanglePostionRelationDeviation,  // 相离
    RectanglePostionRelationintersect,  // 相交
    RectanglePostionRelationinContain   // 包含
} RectanglePostionRelation;

@interface QLXPageViewController ()<QLXScrollViewDelegate>


@property(nonatomic , strong) QLXScrollView * scrollView;
@property(nonatomic , strong) NSMutableDictionary * controllerLifecycleDic;
@property(nonatomic , strong) UIViewController * selectedController;


@end

@implementation QLXPageViewController

@synthesize selectedIndex = _selectedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    if (_viewControllers != viewControllers) {
        [self.scrollView removeAllSubivews];
        _viewControllers = viewControllers;
        UIViewController * lastController = nil;
        for (UIViewController * controller in _viewControllers) {
//            [self addChildViewController:controller];
//            [controller didMoveToParentViewController:self];
            [self.scrollView addSubview:controller.view];
            [controller.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView);
                if (lastController) {
                    make.left.equalTo(lastController.view.mas_right);
                }else {
                    make.left.equalTo(self.scrollView);
                }
                make.width.equalTo(self.scrollView);
                make.height.equalTo(self.scrollView);
            }];
            lastController = controller;
        }
        kBlockWeakSelf;
        NSUInteger count = _viewControllers.count;
        [self.view performInNextLoopWithBlock:^{
            weakSelf.scrollView.contentSize =CGSizeMake(weakSelf.view.width * count , weakSelf.view.height);
        }];
    }
}

-(QLXScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [QLXScrollView new];
        [self.view addSubview:_scrollView];
        _scrollView.pagingEnabled = true;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.bounces = false;
        [_scrollView constraintWithEdgeZero];
    }
    return _scrollView;
}


-(void)scrollView:(UIScrollView *)scrollView oldContentOffset:(CGPoint)oldContentOffset newContentOffset:(CGPoint)newContentOffset{
    for (UIViewController * controller in self.viewControllers) {
        NSString * key = [controller address];
        NSString * lastState = [self.controllerLifecycleDic objectForKey:key];
        RectanglePostionRelation old = [self lifecycleWithContrller:controller contentOffset:oldContentOffset];
        RectanglePostionRelation new = [self lifecycleWithContrller:controller contentOffset:newContentOffset];
        
        if (old == RectanglePostionRelationDeviation && (new == RectanglePostionRelationintersect || new == RectanglePostionRelationinContain)) {
            [controller viewWillAppear:true];
            [self.controllerLifecycleDic setObject:@"viewWillAppear" forKey:key];
        }else if(old != RectanglePostionRelationinContain && new == RectanglePostionRelationinContain){
            if (!lastState ||  ![lastState isEqualToString:@"viewWillAppear"]) {
                [controller viewWillAppear:true];
            }
            [controller viewDidAppear:true];
            [self.controllerLifecycleDic setObject:@"viewDidAppear" forKey:key];
        }else if(old == RectanglePostionRelationinContain && new != RectanglePostionRelationinContain){

            [controller viewWillDisappear:true];
            [self.controllerLifecycleDic setObject:@"viewWillDisappear" forKey:key];
        }else if((old == RectanglePostionRelationintersect || old == RectanglePostionRelationinContain) && (new == RectanglePostionRelationDeviation)){
            if (!lastState ||  ![lastState isEqualToString:@"viewWillDisappear"]) {
                [controller viewWillDisappear:true];
            }
            [controller viewDidDisappear:true];
            [self.controllerLifecycleDic setObject:@"viewDidDisappear" forKey:key];
        }
    }
}

-(RectanglePostionRelation) lifecycleWithContrller:(UIViewController *)controller contentOffset:(CGPoint) contentOffset{
    CGFloat x = controller.view.x - contentOffset.x;
    CGFloat width = self.scrollView.width;
    if (x + width <= 0 || x >= width) {
        return  RectanglePostionRelationDeviation;
    }
    if (x == 0) {
        return  RectanglePostionRelationinContain;
    }
    return RectanglePostionRelationintersect;
}



-(NSMutableDictionary *)controllerLifecycleDic{
    if (!_controllerLifecycleDic) {
        _controllerLifecycleDic = [NSMutableDictionary new];
    }
    return _controllerLifecycleDic;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.selectedController viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.selectedController viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.selectedController viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.selectedController viewDidDisappear:animated];
}

-(NSUInteger)selectedIndex{
    NSUInteger index = self.scrollView.contentOffset.x / self.view.width + 0.5;
    return fmin(index, self.viewControllers.count - 1);
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        if ([self.delegate respondsToSelector:@selector(pageViewController:pageChanged:)]) {
            [self.delegate pageViewController:self pageChanged:selectedIndex];
        }
    }
    [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.view.width, 0) animated:false];
}

-(UIViewController *)selectedController{
    return [self.viewControllers objectAtIndex:self.selectedIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat width = self.scrollView.width;
    {
        if (width > 0 ) {
            CGFloat curX = self.scrollView.contentOffset.x;
            NSInteger fromPage = self.selectedIndex;
            CGFloat pageX = fromPage * width;
            CGFloat progress = (curX - pageX) / width;
            
            if (progress != -1 && progress != 1 ) {
                fromPage += (int)(progress);
                progress = progress - ((int)(progress));
            }
            
            if ([self.delegate respondsToSelector:@selector(pageViewController:scrollPageProgress:fromPage:)]) {
                [self.delegate pageViewController:self scrollPageProgress:progress fromPage:fromPage];
            }
            if ([self.delegate respondsToSelector:@selector(pageViewController:scrollProgress:)]) {
                CGFloat scrollWith = self.scrollView.contentSize.width - width;
                
                CGFloat progress = 0;
                if (scrollWith) {
                    progress = curX / scrollWith;
                }
                [self.delegate pageViewController:self scrollProgress:progress];
            }
        }
        
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    {
        CGFloat curX = self.scrollView.contentOffset.x;
        NSInteger newPage = (int)(curX / self.view.width + 0.5);
        self.selectedIndex = newPage;
    }
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    (*targetContentOffset).x -= 20;
    NSLog(@"%.2lf",(*targetContentOffset).x);
}


@end
