//
//  QLXNavigationController.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/26.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXNavigationController.h"
#import "QLXExt.h"
@interface QLXNavigationController ()<UINavigationControllerDelegate , UINavigationBarDelegate >

@property (nonatomic, strong) QLXVCTransitionAnimatorBase * presentAnimator ;
@property (nonatomic, weak) id<QLXNavigationControllerDelegate> navigationDelegate;
@property (nonatomic, strong) UIImage * defaultBarBgImage;

@end

@implementation QLXNavigationController
@synthesize multiNavigationBarEnable = _multiNavigationBarEnable;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}


-(UINavigationBar *)navigationBar{
    QLXNavigationBar * bar = (QLXNavigationBar *)[super navigationBar];
    if ([bar isKindOfClass:[QLXNavigationBar class]] == false) {
        bar = [QLXNavigationBar new];
        bar.delegate = self;
        [self setQLXNavigationBar:bar];// 更换导航栏
    }
    return bar;
}

-(QLXVCTransitionAnimatorBase *)presentAnimator{
    if (!_presentAnimator) {
        _presentAnimator = [QLXVCTransitionPushAnimator new];
    }
    return _presentAnimator;
}

-(void) setQLXNavigationBar:(QLXNavigationBar *)bar{
    [self setValue:bar forKey:@"navigationBar"];
}

-(void) setDefaultBarBgWithImage:(UIImage *)image{
    self.defaultBarBgImage = image;
    [self.navigationBar setBackgroundImage:image forBarPosition:(UIBarPositionAny) barMetrics:(UIBarMetricsDefault)];
}

-(BOOL)getMultiNavigationBarEnable{
    return false;
}

-(void) setTitleColor:(UIColor *)color{
    [self.navigationBar setTitleTextAttributes:@{
                                                 NSForegroundColorAttributeName : color,
                                                 NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:18]
                                                 }];
}

-(void) setNavigationBarBgColor:(UIColor *) color{
    [self setDefaultBarBgWithImage:nil];
    self.navigationBar.barTintColor = color;
}

-(void) setNavigationBarBgImageWithColor:(UIColor *) color{
    [self setDefaultBarBgWithImage:[UIImage imageWithColor:color size:CGSizeMake(1, 1)]];
}

-(void) setNavigationBarBgImage:(UIImage *) image{
    [self setDefaultBarBgWithImage:image];
}

-(void) setBarBottomLineHidden{
    self.barTarget = nil;
    self.navigationBar.shadowImage = [UIImage new];
}


-(void) setTintColor:(UIColor *) color{
    [self.navigationBar setTintColor:color];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if ([self.navigationDelegate respondsToSelector:@selector(preferredStatusBarStyle)]) {
        return [self.navigationDelegate preferredStatusBarStyle];
    }
    return  UIStatusBarStyleDefault;
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL canPush = true;
    if ([self.navigationDelegate respondsToSelector:@selector(navigationController:canPushViewController:animated:)]) {
        canPush = [self.navigationDelegate navigationController:self canPushViewController:viewController animated:animated];
    }
    if (canPush) {
        if (self.viewControllers.count > 0 ) {
            viewController.hidesBottomBarWhenPushed =  true;
        }
        if ([self needPresentController]) {
            [self presentControllerByPushAnimation:viewController];
        }else{
            [super pushViewController:viewController animated:animated];
        }
    }
}

-(BOOL) needPresentController{
    return (self.viewControllers.count > 0 && self.multiNavigationBarEnable) &&
    ([self getNavigationBar].bgImage!= self.defaultBarBgImage ||
     [self getNavigationBar].hidden );
}

-(void) presentControllerByPushAnimation:(UIViewController *)viewController{
    
    QLXNavigationController * vc = (QLXNavigationController *)viewController;
    if (![vc isKindOfClass:[QLXNavigationController class]]) {
        vc =  [[[self class] alloc] initWithRootViewController:viewController];
    }else {
        viewController = (UIViewController *)vc.viewControllers.firstObject;
    }
  //  viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:vc action:@selector(goBack) image:@"nav_back" highImage:@"nav_back_on"];
    
    vc.rootNavigationController = [self rootNavigationController];
    self.presentAnimator.destinationController = vc;
    self.presentAnimator.transitionType = QLXVCTransitonTypePresentation | QLXVCTransitonTypeDismiss | QLXVCTransitonTypeInteractionDismiss;
    vc.transitioningDelegate = self.presentAnimator;
    [self.visibleViewController presentViewController:vc animated:true completion:nil];
}

-(void)goBack{
    [self popViewControllerAnimated:true];
}


-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    BOOL canPop = true;
    if ([self.navigationDelegate respondsToSelector:@selector(navigationController:canPopViewControllerAnimated:)]) {
        canPop = [self.navigationDelegate navigationController:self canPopViewControllerAnimated:animated];
    }
    if (canPop) {
        if (self.viewControllers.count == 1) {
            [self dismissViewControllerAnimated:animated completion:nil];
        }else {
            [super popViewControllerAnimated:animated];
        }
    }
    return nil;
}


-(void)setMultiNavigationBarEnable:(BOOL)multiNavigationBarEnable{
    if (multiNavigationBarEnable) {
    }
    _multiNavigationBarEnable = multiNavigationBarEnable;
}



-(QLXNavigationBar *) getNavigationBar{
    return (QLXNavigationBar *)self.navigationBar;
}

-(void)setDelegate:(id<UINavigationControllerDelegate>)delegate{
    if (((id)(delegate)) != self) {
        self.navigationDelegate = (id<QLXNavigationControllerDelegate>)delegate;
    }else {
        [super setDelegate:delegate];
    }
}


#pragma mark - UINavigationDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self.navigationDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.navigationDelegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self.navigationDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.navigationDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}


//- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0);
//- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController NS_AVAILABLE_IOS(7_0);
//
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if ([self.navigationDelegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        return [self.navigationDelegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }
    
    return nil;
}
//
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  {
    if ([self.navigationDelegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [self.navigationDelegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    }
    return nil;
    //return [QLXCubeControllerAnimation new];
}



-(NSArray *)popToPreViewControllerWithClass:(Class) class animated:(BOOL)animated{
    NSString * className =   NSStringFromClass(class);
    UIViewController * preVC;
    NSArray * controllers = [self getTotalViewControllers];
    for (UIViewController * child in controllers) {
        if ([[child className] isEqualToString:className]) {
            if (preVC) {
                return [self popToViewController:preVC animated:animated];
            }
        }
        preVC = child;
    }
    return nil;
}

-(NSArray *)popToViewControllerWithClass:(Class) class animated:(BOOL)animated{
    NSString * className =   NSStringFromClass(class);
    NSArray * controllers = [self getTotalViewControllers];
    for (UIViewController * child in controllers) {
        if ([[child className] isEqualToString:className]) {
            return  [self popToViewController:child animated:animated];
        }
    }
    return nil;
}

-(NSArray *)popToViewControllerWithStep:(NSInteger ) step animated:(BOOL)animated{
    NSArray * controllers = [self getTotalViewControllers];
    NSUInteger count = controllers.count;
    if (step < count && step > 0) {
        UIViewController * vc = [controllers objectAtIndex:(count - step - 1 )];
        if (vc) {
            return [self popToViewController:vc animated:animated];
        }
    }
    return nil;
}

-(QLXNavigationController *)rootNavigationController{
    if (!_rootNavigationController) {
        _rootNavigationController = self;
    }
    return _rootNavigationController;
}


-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    if (self.rootNavigationController != self ) {
        [self.rootNavigationController popToRootViewControllerAnimated:false];
        [self.rootNavigationController dismissViewControllerAnimated:animated completion:nil];
    }else {
        return [super popToRootViewControllerAnimated:animated];
    }
    return nil;
}



-(NSArray *) getTotalViewControllers{
    if (self.rootNavigationController != self) {
        NSMutableArray * controllers = [NSMutableArray new];
        QLXNavigationController * naVc = self.rootNavigationController;
        do {
            [controllers addObjectsFromArray:naVc.viewControllers];
            naVc = [naVc getNextNavigationConroller];
        } while (naVc != nil);
        return controllers;
    }else {
        return self.viewControllers;
    }
}

-(NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    QLXNavigationController * naVc = self.rootNavigationController;
    if (naVc != self && [self.viewControllers containsObject:viewController] == false) {
        while (![naVc.viewControllers containsObject:viewController]) {
            QLXNavigationController * nextNaVC =  [naVc getNextNavigationConroller];
            if (nextNaVC) {
                naVc = nextNaVC;
            }else {
                break;
            }
        }
        QLXNavigationController * nextNaVC =  [naVc getNextNavigationConroller];
        if (naVc.viewControllers.lastObject == viewController) {
            [naVc dismissViewControllerAnimated:animated completion:nil];
        }else if(nextNaVC){
            [naVc popToViewController:viewController animated:false];
            [naVc dismissViewControllerAnimated:animated completion:nil];
        }
        return nil;
    }else {
        return [super popToViewController:viewController animated:animated];
    }
}

-(QLXNavigationController *)getNextNavigationConroller{
    return (QLXNavigationController *)self.presentedViewController;
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    BOOL result = true;
    if ([self.navigationDelegate respondsToSelector:@selector(shouldDismissViewController:)]) {
        result = [self.navigationDelegate shouldDismissViewController:self];
    }
    if (result) {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}


@end
