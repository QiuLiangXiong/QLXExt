//
//  QLXPageAnimator.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/11/20.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXPageAnimator.h"
#import "QLXExt.h"

#define scaleValue 0.7
#define addOffsetValue 0.02
#define vecocityValue 500

@interface QLXPageAnimator()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer * panGR;
@property (nonatomic, assign) CGPoint                initialLocation;
@property (nonatomic, assign) BOOL                   needChangePage;
@property (nonatomic, assign) BOOL                   changePageEnable;
@property (nonatomic, assign) CGFloat                lastRatio;
@property (nonatomic, strong) QLXView                 * lastShotViewTop;
@property (nonatomic, strong) QLXView                 * lastShotViewBottom;
@property (nonatomic, strong) QLXView                 * nextShotViewTop;
@property (nonatomic, strong) QLXView                 * nextShotViewBottom;
@property (nonatomic, assign) BOOL                   isNextPage;
@property (nonatomic, strong) CADisplayLink *        animationTimerDL;
@property (nonatomic, assign) CGFloat                lastProgress;
@property (nonatomic, assign) CGFloat                progressAddOffset;
@property (nonatomic, assign) CGFloat                maxProgress;

@end

@implementation QLXPageAnimator

+(instancetype) createWithTargetView:(UIView *) targetView{
    QLXPageAnimator * animator = [QLXPageAnimator new];
    animator.targetView = targetView;
    return animator;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initConfigs];
    }
    return self;
}

-(void) initConfigs{
    self.maxProgress = 1;
    self.maxProgressWhenNone = 0.4;
    self.direction = QLXPageDirectionVertical;  // 默认纵向 翻页
}

-(void)setTargetView:(UIView *)targetView{
    if (_targetView != targetView) {
        [_targetView removeGestureRecognizer:self.panGR];
        _targetView = targetView;
        _targetView.userInteractionEnabled = true;
        [_targetView addGestureRecognizer:self.panGR];
    }
}

-(UIPanGestureRecognizer *)panGR{
    if (!_panGR) {
        _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panGR.delegate = self;
    }
    return _panGR;
}


#pragma mark UIGEstureRecogizerDelegate

-(void) handlePan:(UIPanGestureRecognizer *) sender{
    CGPoint offset = [sender translationInView:self.targetView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self handleBeginWithOffset:offset];
    }else if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled){
        CGFloat progress = [self getProgressWithOffset:offset];
        [self handleEndWithProgress:progress];
    }else {
        CGFloat progress = [self getProgressWithOffset:offset];
        if (self.needChangePage) {
            [self handlePageWithProgress:progress];
        }else {
            [self handleRotateWithProgress:progress];
        }
    }
}

/**
 *  处理手势begin的操作
 */

-(void) handleBeginWithOffset:(CGPoint) offset{
    self.initialLocation = offset;
    self.needChangePage = true;
    [self refreshLastShotViewTop];
    [self refreshLastShotViewBottom];
}

/**
 *  处理手势离开后的操作
 */
-(void) handleEndWithProgress:(CGFloat) progress{
    CGPoint velocity = [self.panGR velocityInView:self.targetView];
    if (self.needChangePage == false ) {
        if (self.changePageEnable == false && self.maxProgressWhenNone <= 0) {
              
        }else {
            if (self.isNextPage ) {
                if ((self.changePageEnable == false) ||(progress < 0.5 && velocity.y > -vecocityValue)) {  // 撤销 页面改变
                    [self.delegate toLastPageWithPageAnimator:self];
                }
            }else {
                if ((self.changePageEnable == false)||(progress > -0.5 && velocity.y < vecocityValue)) {
                    [self.delegate toNextPageWithPageAnimator:self];
                }
            }
        }
    }
    self.lastRatio = 0;
    self.lastProgress = progress;
    // 处理过度动画
    self.animationTimerDL.paused = false;
    // 上一页
    if (progress < 0) {
        if (velocity.y > vecocityValue && self.changePageEnable) {  // 有资格翻过去
            self.progressAddOffset = -addOffsetValue * fmin(velocity.y / vecocityValue,2.5);
        }else {
            if (progress > -0.5) {
               self.progressAddOffset = addOffsetValue;
            }else {
               self.progressAddOffset = -addOffsetValue;
            }
        }
    }
    // 下一页
    else if(progress > 0){
        if (velocity.y < -vecocityValue && self.changePageEnable) {// 有资格翻过去
            self.progressAddOffset = addOffsetValue * fmin(velocity.y /(-vecocityValue),2.5);
        }else {
            if (progress < 0.5) {
                self.progressAddOffset = -addOffsetValue;
            }else {
                self.progressAddOffset = addOffsetValue;
            }
        }
    }else {
        self.animationTimerDL.paused = true;
        [self.lastShotViewBottom removeFromSuperview];
        [self.lastShotViewTop removeFromSuperview];
        [self.nextShotViewBottom removeFromSuperview];
        
        [self.nextShotViewTop removeFromSuperview];
    }
}
/**
 *  处理手势确定了方向的操作
 */

-(void) handlePageWithProgress:(CGFloat)progress{
    if (progress < 0) {
        self.needChangePage = false;
        self.isNextPage = false;
        self.changePageEnable = [self.delegate toLastPageWithPageAnimator:self];
        self.maxProgress = self.changePageEnable? 1: self.maxProgressWhenNone;
    }else if(progress > 0){
        self.needChangePage = false;
        self.isNextPage = true;
        self.changePageEnable = [self.delegate toNextPageWithPageAnimator:self];
        self.maxProgress = self.changePageEnable? 1: self.maxProgressWhenNone;
    }else {
        self.maxProgress = 1;
    }
    kBlockWeakSelf;
    [self.targetView performInNextLoopWithBlock:^{
        [weakSelf refreshNextShotViewTop];
        [weakSelf refreshNextShotViewBottom];
        UIView * superView = weakSelf.targetView.superview;
        [superView addSubview:self.nextShotViewTop];
        [superView addSubview:self.nextShotViewBottom];
        [superView addSubview:self.lastShotViewTop];
        [superView addSubview:self.lastShotViewBottom];
    }];
}

/**
 *  处理手势移动进行时的操作
 */
-(void) handleRotateWithProgress:(CGFloat) progress{
    
    if (progress < 0) { // 上一页 向下翻
        if (progress >= -0.5) {   // 一半不到
            self.lastShotViewTop.hidden = false;
            self.nextShotViewBottom.layer.transform = [self getTransForm3DWithAngle:0];;
            self.lastShotViewTop.layer.transform = [self getTransForm3DWithAngle:progress * 180 / 180 * M_PI];
            
            self.nextShotViewTop.mask.alpha = 0.8 * (1 - 2 * fabs(progress));
            self.lastShotViewBottom.mask.alpha = 0;
            
        }else {
            self.lastShotViewTop.hidden = true;
            CGFloat pro = (1 - fabs(progress));
            self.lastShotViewBottom.hidden = pro < 0.05;
            self.nextShotViewBottom.layer.transform = [self getTransForm3DWithAngle:pro * 180 / 180 * M_PI];
            self.lastShotViewBottom.mask.alpha = 0.8 * (2 * (fabs(progress) - 0.5));
            self.nextShotViewTop.mask.alpha = 0;
        }
    }
    else if (progress > 0) { // 下一页 向上翻
        if (progress <= 0.5) {  // 一半不到
            self.lastShotViewBottom.hidden = false;
            self.nextShotViewTop.layer.transform = [self getTransForm3DWithAngle:0];;
            self.lastShotViewBottom.layer.transform = [self getTransForm3DWithAngle:progress * 180 / 180 * M_PI];
            self.nextShotViewBottom.mask.alpha = 0.8 * (1 - 2 * (fabs(progress)));
            self.lastShotViewTop.mask.alpha = 0;
        }else {
            self.lastShotViewBottom.hidden = true;
            CGFloat pro = (1 - fabs(progress));
            self.lastShotViewTop.hidden = pro < 0.05;
            self.nextShotViewTop.layer.transform = [self getTransForm3DWithAngle:-pro * 180 / 180 * M_PI];
            self.lastShotViewTop.mask.alpha = 0.8 * (2 * (fabs(progress) - 0.5));
            self.nextShotViewBottom.mask.alpha = 0;
        }
    }
}

/**
 *  获得旋转角度
 */

-(CATransform3D)getTransForm3DWithAngle:(CGFloat)angle{
    CATransform3D  transform = CATransform3DIdentity;
    transform.m34 =  1.0 / -3000;
    transform  = CATransform3DRotate(transform,angle, 1, 0, 0);
    return transform;
}

/**
 *  获得滑动进度
 */
-(CGFloat) getProgressWithOffset:(CGPoint) offset{
    CGFloat length;
    if (self.direction == QLXPageDirectionVertical) {
        length = self.targetView.height * scaleValue;
        assert(length);
        CGFloat panLenth = self.initialLocation.y - offset.y;
        CGFloat ratio = panLenth / length;
        if (self.lastRatio * ratio < 0) {
            return 0;
        }
        self.lastRatio = ratio;
        return fmin(self.maxProgress, fmax(ratio, -self.maxProgress)) ;
    }else {
        length = self.targetView.width * scaleValue;
        assert(length);
        CGFloat panLenth =self.initialLocation.x - offset.x ;
        CGFloat ratio = panLenth / length;
        if (self.lastRatio * ratio <= 0) {
            return 0;
        }
        self.lastRatio = ratio;
        return fmin(self.maxProgress, fmax(ratio, -self.maxProgress)) ;
    }
}


-(void) refreshLastShotViewTop{
    for (UIView * sub in self.lastShotViewTop.subviews) {
        [sub removeFromSuperview];
    }
    UIView * shotView = [self.targetView snapshotViewAfterScreenUpdates:false];
    self.lastShotViewTop.hidden = false;

    self.lastShotViewTop.layer.transform = [self getTransForm3DWithAngle:0];
    [self.lastShotViewTop addSubview:shotView];
    self.lastShotViewTop.mask.alpha = 0;
}

-(void) refreshLastShotViewBottom{
    for (UIView * sub in self.lastShotViewBottom.subviews) {
        [sub removeFromSuperview];
    }
    UIView * shotView = [self.targetView snapshotViewAfterScreenUpdates:false];
    [self.lastShotViewBottom addSubview:shotView];
    self.lastShotViewBottom.hidden = false;
    self.lastShotViewBottom.layer.transform = [self getTransForm3DWithAngle:0];
    shotView.y -= self.targetView.height / 2;
    self.lastShotViewBottom.mask.alpha = 0;
}

-(void) refreshNextShotViewTop{
    for (UIView * sub in self.nextShotViewTop.subviews) {
        [sub removeFromSuperview];
    }
    UIView * shotView = [self.targetView snapshotViewAfterScreenUpdates:true];
    [self.nextShotViewTop addSubview:shotView];
    self.nextShotViewTop.hidden = false;
    self.nextShotViewTop.layer.transform = [self getTransForm3DWithAngle:0];
    self.nextShotViewTop.mask.alpha = 0;
}

-(void) refreshNextShotViewBottom{
    for (UIView * sub in self.nextShotViewBottom.subviews) {
        [sub removeFromSuperview];
    }
    UIView * shotView = [self.targetView snapshotViewAfterScreenUpdates:true];
    [self.nextShotViewBottom addSubview:shotView];
    self.nextShotViewBottom.hidden = false;
    self.nextShotViewBottom.layer.transform = [self getTransForm3DWithAngle:0];
    shotView.y -= self.targetView.height / 2;
    self.nextShotViewBottom.mask.alpha = 0;
}

-(UIView *)lastShotViewTop{
    if (!_lastShotViewTop) {
        _lastShotViewTop = [QLXView createWithBgColor:[UIColor clearColor]];
        _lastShotViewTop.clipsToBounds = true;
        _lastShotViewTop.frame = self.targetView.frame;
        _lastShotViewTop.height = self.targetView.height / 2;
        _lastShotViewTop.y += self.targetView.height / 4;
        _lastShotViewTop.layer.anchorPoint = CGPointMake(0.5, 1);
    }
    return _lastShotViewTop;
}

-(UIView *)lastShotViewBottom{
    if (!_lastShotViewBottom) {
        _lastShotViewBottom = [QLXView createWithBgColor:[UIColor clearColor]];
        _lastShotViewBottom.clipsToBounds = true;
        logFrame(self.targetView);
        _lastShotViewBottom.frame = self.targetView.frame;
        _lastShotViewBottom.height = self.targetView.height / 2;
        _lastShotViewBottom.layer.anchorPoint = CGPointMake(0.5, 0);
        _lastShotViewBottom.y += self.targetView.height / 4;
    }
    return _lastShotViewBottom;
}

-(UIView *)nextShotViewTop{
    if (!_nextShotViewTop) {
        _nextShotViewTop = [QLXView createWithBgColor:[UIColor clearColor]];
        _nextShotViewTop.clipsToBounds = true;
        
        _nextShotViewTop.frame = self.targetView.frame;
        _nextShotViewTop.height = self.targetView.height / 2;
        _nextShotViewTop.y += self.targetView.height / 4;
        _nextShotViewTop.layer.anchorPoint = CGPointMake(0.5, 1);
    }
    return _nextShotViewTop;
}

-(UIView *)nextShotViewBottom{
    if (!_nextShotViewBottom) {
        _nextShotViewBottom = [QLXView createWithBgColor:[UIColor clearColor]];
        _nextShotViewBottom.clipsToBounds = true;
        _nextShotViewBottom.frame = self.targetView.frame;
        _nextShotViewBottom.height = self.targetView.height / 2;
        _nextShotViewBottom.layer.anchorPoint = CGPointMake(0.5, 0);
        _nextShotViewBottom.y += self.targetView.height / 4;
    }
    return _nextShotViewBottom;
}


-(CADisplayLink *)animationTimerDL{
    if (!_animationTimerDL) {
        _animationTimerDL = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationProgress)];
        _animationTimerDL.paused = true;
        [_animationTimerDL addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _animationTimerDL;
}

-(void) animationProgress{
    
    CGFloat last = self.lastProgress;
    
    self.lastProgress += self.progressAddOffset;
    if (self.lastProgress <= -1 || self.lastProgress >= 1 || (self.lastProgress * last) < 0) {
        self.animationTimerDL.paused = true;
        [self.lastShotViewTop removeFromSuperview];
        [self.lastShotViewBottom removeFromSuperview];
        [self.nextShotViewBottom removeFromSuperview];
        [self.nextShotViewTop removeFromSuperview];
    }
    [self handleRotateWithProgress:self.lastProgress];
}



@end
