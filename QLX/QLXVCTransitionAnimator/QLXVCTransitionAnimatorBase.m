//
//  QLXVCTransitionAnimatorBase.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/10/10.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXVCTransitionAnimatorBase.h"

@interface QLXVCTransitionAnimatorBase()

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer * popGestrureRecognizer;



@end
@implementation QLXVCTransitionAnimatorBase


-(instancetype)init{
    self = [super init];
    if (self) {
        [self initConfigs];
    }
    return self;
}

-(void) initConfigs{
    self.transitionType = QLXVCTransitonTypeNone;
}

#pragma mark -  UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.501f;// default duration is 0.5f
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    self.fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.containerView = [transitionContext containerView];
}


#pragma mark -  UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    if (self.transitionType & QLXVCTransitonTypePresentation) {
        self.isDimiss = false;
        return self;
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    if (self.transitionType & QLXVCTransitonTypeDismiss) {
        self.isDimiss = true;
        return self;
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    if (self.transitionType & QLXVCTransitonTypeInteractionPresentation) {
        self.isDimiss = false;
        return self.interactiveTransition;
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    if (self.transitionType & QLXVCTransitonTypeInteractionDismiss) {
        self.isDimiss = true;
        return self.interactiveTransition;
    }
    return nil;
}


#pragma mark -  UINavigationControllerDelegate

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if (self.transitionType & QLXVCTransitonTypeInteractionPop) {
        self.isPop = true;
        return self.interactiveTransition;
    }
    return nil;
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if ((self.transitionType & QLXVCTransitonTypePush ) ) {
        self.isPop = operation == UINavigationControllerOperationPop;
        return self;
    }
    return nil;
}

-(void)setTransitionType:(QLXVCTransitonType)transitionType{
    _transitionType = transitionType;
    if (
        (_transitionType & QLXVCTransitonTypeInteractionPop) ||
        (_transitionType & QLXVCTransitonTypeInteractionDismiss)
       )
    {
        assert(self.destinationController); // 未设置 目标控制  请先设置 在 设置这个属性哦
        [self.destinationController.view addGestureRecognizer:self.popGestrureRecognizer];
    }
}

-(UIScreenEdgePanGestureRecognizer *)popGestrureRecognizer{
    if (!_popGestrureRecognizer) {
        _popGestrureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopGesture:)];
        _popGestrureRecognizer.edges = UIRectEdgeLeft; // 默认左边
        _popGestrureRecognizer.delegate = self;
    }
    return _popGestrureRecognizer;
}

// 经过这样设计  已经成为固定模板 perfect
-(void) handlePopGesture:(UIScreenEdgePanGestureRecognizer *) gesture{
     // 计算用户滑动进度百分比
    CGFloat progress = [self getInteractiveProgressWithGesture:gesture];
    progress = fmin(1.0 , fmax(0.0,progress)); // 这样可以保证 progress 在 [0 , 1]
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self interactiveBeginWithProgress:progress];
    }else if(gesture.state == UIGestureRecognizerStateChanged){
        // 更新 interactivePopTransition 进度
        [self interactiveChangeWithProgress:progress];
    }else if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
        // 完成或者取消过渡
        if ([self finishInteractiveTransitionWithProgress:progress]) {
            [self.interactiveTransition finishInteractiveTransition];
        }else {
            [self.interactiveTransition cancelInteractiveTransition];
        }
        self.interactiveTransition = nil;   // 要立即取消
    }
    
}

-(BOOL) finishInteractiveTransitionWithProgress:(CGFloat)progress{
    return progress > 0.25;
}

- (CGFloat) getInteractiveProgressWithGesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    return [gesture translationInView:self.destinationController.view].x / self.destinationController.view.bounds.size.width;
}

-(void)  interactiveBeginWithProgress:(CGFloat)progress{
    self.interactiveTransition = self;
    if (self.transitionType & QLXVCTransitonTypePush) {
        if ([self.destinationController isKindOfClass:[UINavigationController class]]) {
            UINavigationController * naVC = (UINavigationController *)self.destinationController;
            [naVC popViewControllerAnimated:true];
        }
    }else if(self.transitionType & QLXVCTransitonTypeInteractionDismiss){
        [self.destinationController dismissViewControllerAnimated:true completion:nil];//
    }
}

-(void)  interactiveChangeWithProgress:(CGFloat)progress{
    
    [self.interactiveTransition updateInteractiveTransition:progress];
}




#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return false;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  
    return false;
}





@end
