//
//  QLXTabBarController.m
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXTabBarController.h"
#import "QLXExt.h"

@interface QLXTabBarController ()<UITabBarControllerDelegate , QLXTarbarVCTransitionPaddingAnimatorDelegate>

@property(nonatomic , weak) id<UITabBarControllerDelegate> paddingAnimatorDelegate;
@property(nonatomic , strong) QLXTarbarVCTransitionPaddingAnimator * animator;


@end

@implementation QLXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBar.translucent = false;// 如果不设置非透明  切换后台的时候底部会黑一下
    self.paddingEnable = true;  //  默认可以滑动翻页
    
    
    
}

-(QLXTarbarVCTransitionPaddingAnimator *)animator{
    if (!_animator) {
        _animator = [QLXTarbarVCTransitionPaddingAnimator new];
        _animator.destinationController = self;
        _animator.delegate = self;
        self.paddingAnimatorDelegate = _animator;
    }
    return _animator;
}



-(void)setPaddingEnable:(BOOL)paddingEnable{
    _paddingEnable = paddingEnable;
    if (_paddingEnable) {
        self.paddingAnimatorDelegate = self.animator;
    }else {
        self.paddingAnimatorDelegate = nil;
        self.animator = nil;
    }
}

-(void)setDelegate:(id<UITabBarControllerDelegate>)delegate{
    if (delegate == self) {
        [super setDelegate:delegate];
    }else {
        self.tabBarControllerDelegate = (id<QLXTabBarControllerDelegate> )delegate;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


#pragma mark QLXTarbarVCTransitionPaddingAnimatorDelegate

-(BOOL)animator:(QLXTarbarVCTransitionPaddingAnimator *)animator gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:shouldReciveTouch:)]) {
        return [self.tabBarControllerDelegate tabBarController:self shouldReciveTouch:touch];
    }
    return true;
}

#pragma mark UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
       return  [self.tabBarControllerDelegate tabBarController:tabBarController shouldSelectViewController:viewController];
    }
    if ([self.paddingAnimatorDelegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        return  [self.paddingAnimatorDelegate tabBarController:tabBarController shouldSelectViewController:viewController];
    }
    return true;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        return  [self.tabBarControllerDelegate tabBarController:tabBarController didSelectViewController:viewController];
    }
    if ([self.paddingAnimatorDelegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        return  [self.paddingAnimatorDelegate tabBarController:tabBarController didSelectViewController:viewController];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    if ([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:willBeginCustomizingViewControllers:)]) {
        [self.tabBarControllerDelegate tabBarController:tabBarController willBeginCustomizingViewControllers:viewControllers];
    }
    if ([self.paddingAnimatorDelegate respondsToSelector:@selector(tabBarController:willBeginCustomizingViewControllers:)]) {
        [self.paddingAnimatorDelegate tabBarController:tabBarController willBeginCustomizingViewControllers:viewControllers];
    }
}
- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers changed:(BOOL)changed {
    if ([self.tabBarControllerDelegate respondsToSelector:@selector(tabBar:willEndCustomizingItems:changed:)]) {
        [self.tabBarControllerDelegate tabBarController:tabBarController willEndCustomizingViewControllers:viewControllers changed:changed];
    }
    if ([self.paddingAnimatorDelegate respondsToSelector:@selector(tabBar:willEndCustomizingItems:changed:)]) {
        [self.paddingAnimatorDelegate tabBarController:tabBarController willEndCustomizingViewControllers:viewControllers changed:changed];
    }
}
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers changed:(BOOL)changed {
    if ([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:didEndCustomizingViewControllers:changed:)]) {
        [self.tabBarControllerDelegate tabBarController:tabBarController didEndCustomizingViewControllers:viewControllers changed:changed];
    }
    if ([self.paddingAnimatorDelegate respondsToSelector:@selector(tabBarController:didEndCustomizingViewControllers:changed:)]) {
        [self.paddingAnimatorDelegate tabBarController:tabBarController didEndCustomizingViewControllers:viewControllers changed:changed];
    }
}

- (UIInterfaceOrientationMask)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController {
    if ([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarControllerSupportedInterfaceOrientations:)]) {
        return [self.tabBarControllerDelegate tabBarControllerSupportedInterfaceOrientations:tabBarController];
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)tabBarControllerPreferredInterfaceOrientationForPresentation:(UITabBarController *)tabBarController {
    if ([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [self.tabBarControllerDelegate tabBarControllerPreferredInterfaceOrientationForPresentation:tabBarController];
    }
    return UIInterfaceOrientationUnknown;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                               interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController {
    if ([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:interactionControllerForAnimationController:)]) {
        return [self.tabBarControllerDelegate tabBarController:tabBarController interactionControllerForAnimationController:animationController];
    }
    if ([self.paddingAnimatorDelegate respondsToSelector:@selector(tabBarController:interactionControllerForAnimationController:)]) {
        return [self.paddingAnimatorDelegate tabBarController:tabBarController interactionControllerForAnimationController:animationController];
    }
    return nil;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC {
    if ([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:animationControllerForTransitionFromViewController:toViewController:)]) {
        return [self.tabBarControllerDelegate tabBarController:tabBarController animationControllerForTransitionFromViewController:fromVC toViewController:toVC];
    }
    if ([self.paddingAnimatorDelegate respondsToSelector:@selector(tabBarController:animationControllerForTransitionFromViewController:toViewController:)]) {
        return [self.paddingAnimatorDelegate tabBarController:tabBarController animationControllerForTransitionFromViewController:fromVC toViewController:toVC];
    }
    return nil;
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
