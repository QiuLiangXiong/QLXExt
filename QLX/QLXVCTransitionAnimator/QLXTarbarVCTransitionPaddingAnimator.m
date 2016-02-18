//
//  QLXTarbarVCTransitionPaddingAnimator.m
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXTarbarVCTransitionPaddingAnimator.h"
#import "QLXExt.h"

#define VelictyBase 500

@interface QLXTarbarVCTransitionPaddingAnimator ()<QLXPanGestureRecognizerDelegate>

@property(nonatomic , assign) BOOL isNextPage;
@property(nonatomic , assign) CGFloat velicity;
@property(nonatomic , assign) BOOL animating;
@property(nonatomic , strong) QLXPanGestureRecognizer * panGR;

@end

@implementation QLXTarbarVCTransitionPaddingAnimator


#pragma mark UITabBarControllerDelegate


- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                               interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController{

    
    return self.interactiveTransition;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC {

   
    return self.interactiveTransition ;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (self.animating == false && self.panGR.paning == false) {
        self.animating = true;
        return true;
    }else {
        return false;
    }
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    self.animating = false;
}

//-----------------------------------代理结束




/**
 *  动画时间
 *
 *  @param transitionContext
 */
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    if (!transitionContext.isInteractive) {
        return 0;
    }
    return 0.4;
}

/**
 *  动画都是在这里做的
 *
 *  @param transitionContext
 */
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    [super animateTransition:transitionContext];
    if (transitionContext.isInteractive) {
        [self interactionPopAmimation:transitionContext];
    }

}

/**
 *  手势动画
 *
 *  @param transitionContext
 */
-(void) interactionPopAmimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    self.animating = true;
   
    CGRect startFrame = self.containerView.bounds;

    CGRect endFrame = self.containerView.bounds;
              
    [self.containerView addSubview:self.toViewController.view];
    self.fromViewController.view.frame = startFrame;
   
    kBlockWeakSelf;
    if (self.isNextPage) {
        startFrame.origin.x = -startFrame.size.width;
        self.fromViewController.view.x += 1;
        self.toViewController.view.x = endFrame.size.width  ;
    }else {
        startFrame.origin.x = startFrame.size.width;
        self.fromViewController.view.x -= 1;
        self.toViewController.view.x = -endFrame.size.width ;
        [self.fromViewController.view bringToFront]; // 解决黑线问题
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext]  animations:^{
        weakSelf.fromViewController.view.frame = startFrame;
        weakSelf.toViewController.view.frame = endFrame;
    } completion:^(BOOL finished) {
        [GCDQueue executeInMainQueue:^{
            weakSelf.animating = false;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        } afterDelaySecs:0.02];// ios7 需要下一帧结束 所以稍微延迟洗a
    }];
}


- (CGFloat) getInteractiveProgressWithGesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    CGPoint point = [gesture translationInView:self.destinationController.view];
    CGPoint v = [gesture velocityInView:self.destinationController.view];
    self.velicity = v.x;
    if (self.isNextPage ) {
        if (point.x > 0) {
            point.x = 0;
        }
    }else{
        if (point.x < 0) {
            point.x = 0;
        }
    }
    return fabs(point.x) / self.destinationController.view.width;
}


-(void)interactiveBeginWithProgress:(CGFloat)progress{

    [super interactiveBeginWithProgress:progress];
    self.isNextPage = [self.panGR isLeftWhenBegin];
    if ([self.destinationController isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tabVC = (UITabBarController *)self.destinationController;
        NSInteger nextIndex = tabVC.selectedIndex + (self.isNextPage? 1 : -1);
        if (nextIndex < 0 || nextIndex >= tabVC.viewControllers.count) {
            self.interactiveTransition = nil;
            //self.animating = false;
        }else {
            tabVC.selectedIndex = nextIndex;
        }
        
    }
}

// 手势取消后 判断下一页滑动是否成功。

-(BOOL) finishInteractiveTransitionWithProgress:(CGFloat)progress{
    BOOL resutl = false;
    if (self.isNextPage) {
        resutl = self.velicity < - VelictyBase || progress > 0.5;
    }else {
        resutl = self.velicity > VelictyBase || progress > 0.5;
    }
    return resutl;
}

-(void)setDestinationController:(UIViewController *)destinationController{
    assert([destinationController isKindOfClass:[UITabBarController class]]);
    if ([super destinationController] != destinationController) {
        [self.destinationController.view removeGestureRecognizer:self.panGR];
        [super setDestinationController:destinationController];
        [destinationController.view addGestureRecognizer:self.panGR];
        self.panGR.targetView = destinationController.view;
        destinationController.view.exclusiveTouch = true;
    }
}



#pragma mark UIPanGesTureDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{


    CGPoint cur =  [touch locationInView:self.destinationController.view];
    if ((cur.y > (self.destinationController.view.height -49))) {
        return false;
    }
    if(((UITabBarController *)self.destinationController).tabBar.hidden){
        return false;
    }
    if (self.animating) {
        return false;
    }
    return true;
}


-(BOOL)gestureRecognizer:(QLXPanGestureRecognizer *)gestureRecognizer shouldBeginWithVelocity:(CGPoint)veloctiy{
    if (self.animating) {
        return false;
    }
    if ([self.delegate respondsToSelector:@selector(animator:gestureRecognizer:shouldBeginWithVelocity:)]) {
        return [self.delegate animator:self gestureRecognizer:gestureRecognizer shouldBeginWithVelocity:veloctiy];
    }
    return true;
}



-(QLXPanGestureRecognizer *)panGR{
    if (!_panGR) {
        _panGR = [[QLXPanGestureRecognizer alloc] init];
        [_panGR addTarget:self action:@selector(handlePopGesture:)];
        _panGR.panDelegate = self;
        _panGR.direction = QLXPanGestureRecognizerDirectionHorizontal;
    }
    return _panGR;
}

-(void)dealloc{
    [self.destinationController.view removeGestureRecognizer:self.panGR];
}


@end
