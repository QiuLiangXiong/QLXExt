//
//  QLXViewController.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/15.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXViewController.h"
#import "QLXExt.h"
@interface QLXViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic , strong)  UITabBarItem * __tarbarItem;

@end

@implementation QLXViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.view.clipsToBounds = true;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.navigationController.viewControllers count] >= 2)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([self.navigationController.viewControllers count] < 2)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}



-(UIView *)bg{
    if (!_bg) {
        _bg = [QLXView createWithBgColor:[UIColor clearColor]];
        _bg.clipsToBounds = true;
        [self.view addSubview:_bg];
        [_bg constraintWithEdgeZero];
    }
    return _bg;
}







// 通过重写这个方法来设置这个属性
-(UITabBarItem *) getTabBarItem{
    return nil;
}

-(UITabBarItem *)tabBarItem{
    if (___tarbarItem == nil) {
        ___tarbarItem = [self getTabBarItem];
        if (___tarbarItem) {
            [super setTabBarItem:___tarbarItem];
        }else {
            return [super tabBarItem];
        }
    }
    return [super tabBarItem];
}









//
//-(UIView *)bgView{
//    if (!_bgView) {
//        _bgView = [UIView new];
//        _bgView.backgroundColor = [UIColor whiteColor];NSString
//        
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
