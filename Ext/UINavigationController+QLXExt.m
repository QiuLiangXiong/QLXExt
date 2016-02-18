//
//  UINavigationController+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/26.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "UINavigationController+QLXExt.h"
#import "QLXExt.h"


@implementation UINavigationController(QLXExt)



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  退回到 class 的前一个
 *
 *  @param class    类
 *  @param animated 是否有动画
 */

-(NSArray *)popToPreViewControllerWithClass:(Class) class animated:(BOOL)animated{
    return nil;
}


/**
 *  退回到 class
 *
 *  @param class
 *  @param animated
 */
-(NSArray *)popToViewControllerWithClass:(Class) class animated:(BOOL)animated{
    return nil;
}
/**
 *  后退几步
 *
 *  @param step     <#step description#>
 *  @param animated <#animated description#>
 */
-(NSArray *)popToViewControllerWithStep:(NSInteger ) step animated:(BOOL)animated{
    return nil;
}

-(void)pushViewControllerWithClass:(Class) aClass  animated:(BOOL) animated{
    UIViewController * vc = [aClass new];
    [self pushViewController:vc animated:animated];
}

-(void)pushViewController:(UIViewController *)viewController sameBarBackground:(BOOL)same{
    QLXNavigationController * naVC = (QLXNavigationController *)self;
    assert([naVC isKindOfClass:[QLXNavigationController class]]); // 导航控制不是QLXNavigationController 不能用此方法
    if (same) {
        [naVC pushViewController:viewController animated:true];
    }else {
        [naVC presentControllerByPushAnimation:viewController];
    }
}

-(void) presentControllerByPushAnimation:(UIViewController *)viewController{
    QLXNavigationController * naVC = (QLXNavigationController *)self;
    assert([naVC isKindOfClass:[QLXNavigationController class]]); // 导航控制不是
    [naVC presentControllerByPushAnimation:viewController];
}






/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
