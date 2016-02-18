//
//  UIView+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "UIView+QLXExt.h"
#import "QLXExt.h"
#include <objc/runtime.h>


@interface UIView()

@end

@implementation UIView(QLXExt)

@dynamic firstEnter;
@dynamic nextLoopCallback;
@dynamic touchFrameAddEdge;

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
}

- (CGPoint)leftTop
{
    CGPoint result = CGPointMake(self.frame.origin.x, self.frame.origin.y);
    return result;
}

- (void)setLeftTop:(CGPoint)leftTop
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(leftTop.x, leftTop.y, frame.size.width, frame.size.height);
}

- (CGPoint)rightBottom
{
    CGPoint result = CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.frame.size.height);
    return result;
}

- (void)setRightBottom:(CGPoint)rightBottom
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(rightBottom.x - frame.size.width, rightBottom.y - frame.size.height, frame.size.width, frame.size.height);
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(left, frame.origin.y, frame.size.width, frame.size.height);
}

- (CGFloat)left;
{
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(right - frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}


- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}



- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}



-(void) constraintWithEqual:(UIView *)toView top:(CGFloat) top centerX:(CGFloat) centerX width:(CGFloat)width height:(CGFloat)height{
    [self mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(toView.mas_bottom).offset((top));
        make.centerX.equalTo(toView.mas_centerX).offset( (centerX) );
        make.width.mas_equalTo((width));
        make.height.mas_equalTo((height));
    }];
}
-(void) constraintWithTop:(CGFloat) top centerX:(CGFloat) centerX width:(CGFloat)width height:(CGFloat)height{
    assert(self.superview != nil);
    
    [self mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.superview.mas_top).offset((top));
        make.centerX.equalTo(self.superview.mas_centerX).offset( (centerX));
        make.width.mas_equalTo( (width));
        make.height.mas_equalTo( (height));
    }];
}

-(void) constraintWithEqual:(UIView *)toView top:(CGFloat) top centerX:(CGFloat) centerX {
    [self mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(toView.mas_bottom).offset(  (top));
        make.centerX.equalTo(toView.mas_centerX).offset( (centerX) );
    }];
}

-(void) constraintWithTop:(CGFloat) top centerX:(CGFloat) centerX {
    assert(self.superview != nil);
    [self mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.superview.mas_top).offset(  (top));
        make.centerX.equalTo(self.superview.mas_centerX).offset( ( centerX));
    }];
}
-(void) constraintWithEdgeZero{
    assert(self.superview != nil);
    [self mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.superview);
        make.left.equalTo(self.superview);
        make.right.equalTo(self.superview);
        make.bottom.equalTo(self.superview);
    }];
}

-(void) constraintWithEdge:(UIEdgeInsets) edge{
    assert(self.superview != nil);
    [self mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.superview).offset(edge.top);
        make.left.equalTo(self.superview).offset(edge.left);
        make.right.equalTo(self.superview).offset(-edge.right);
        make.bottom.equalTo(self.superview).offset(-edge.bottom);
    }];
}

-(void) remakeConstraintWithEdge:(UIEdgeInsets) edge{
    assert(self.superview != nil);
    [self mas_remakeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.superview).offset(edge.top);
        make.left.equalTo(self.superview).offset(edge.left);
        make.right.equalTo(self.superview).offset(-edge.right);
        make.bottom.equalTo(self.superview).offset(-edge.bottom);
    }];
}
-(void) constraintWithEdgeZeroWithView:(UIView *) view{
    assert(view != nil);
    [self mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(view);
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.bottom.equalTo(view);
    }];
}


-(void) updateTopWithOffset:(CGFloat) offset{
    assert(self.superview != nil);
    [self mas_updateConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.superview).offset(offset);
    }];
}
-(void) updateLeftWithOffset:(CGFloat) offset{
    assert(self.superview != nil);
    [self mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.superview).offset(offset);
    }];
}
-(void) updateBottomWithOffset:(CGFloat) offset{
    assert(self.superview != nil);
    [self mas_updateConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.superview).offset(offset);
    }];
}
-(void) updateRightWithOffset:(CGFloat) offset{
    assert(self.superview != nil);
    [self mas_updateConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.superview).offset(offset);
    }];
}
// 根据屏幕的不同 返回iphone6 和 其他屏幕的宽度比例
+(CGFloat) scaleX{
    CGSize size = [UIScreen mainScreen].bounds.size;
    return size.width/375.0;
}
// 根据屏幕的不同 返回iphone6 和 其他屏幕的高度比例
+(CGFloat) scaleY{
    CGSize size = [UIScreen mainScreen].bounds.size;
    return size.height/667.0;
}

-(CGSize) getLayoutSize{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self needsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    return [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

-(void) animateWithShakeWithDuration:(CGFloat) duration force:(CGFloat) force {
    [self.layer addKeyframeAnimation:(KeyPathTypePositionX) WithBlock:^(QLXKeyframeAnimation *animation) {
        animation.values = @[@0,@(30*force),@(-30*force),@(30*force),@(-30*force),@(30*force) ,@0];
        animation.duration = duration;
        animation.additive = true;
    }];
}
-(void) animateWithShake{
    [self animateWithShakeWithDuration:0.2 force:0.3];
}

-(void) animateFromBootomToShow{
    self.alpha = 0.00001;
    kBlockWeakSelf;
    [self.layer addBasicAnimation:KeyPathTypePositionY WithBlock:^(QLXBasicAnimation *animation) {
        animation.fromValue = @(self.y + self.height * 1.5);
        animation.toValue = @(self.y + self.height /2);
        animation.beginTime = CACurrentMediaTime() + 0.0001;
        //animation.removedOnCompletion = false;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation.view = weakSelf;
        [animation animationStart:^(CAAnimation *anim) {
            ((QLXBasicAnimation *)anim).view.alpha = 1;
        }];
    }];
}

-(void) animateFromBootomToHidden:(BOOL) completeRemoved{
    kBlockWeakSelf;
    [self.layer addBasicAnimation:KeyPathTypePositionY WithBlock:^(QLXBasicAnimation *animation) {
        animation.fromValue = @(self.y + self.height * 0.5);
        animation.toValue = @(self.y + self.height * 1.5);
        animation.removedOnCompletion = false;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [animation animationStop:^(CAAnimation *anim, BOOL finished) {
            if (completeRemoved ) {
                [weakSelf removeFromSuperview];
            }
            
        }];
    }];
}

-(void) animateFromRightToShow{
    // self.alpha = 0.000001;
    //kBlockWeakSelf;
    CATransition * animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.duration = 0.3;
    animation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.subtype = kCATransitionFromRight;
    [self.layer addAnimation:animation forKey:@"ShowFromRight"];
}
-(void) animateFromRightToHiden:(BOOL) completeRemoved{
    kBlockWeakSelf;
    [self.layer addBasicAnimation:KeyPathTypePositionX WithBlock:^(QLXBasicAnimation *animation) {
        animation.fromValue = @(self.x + self.width * 0.5);
        animation.toValue = @(self.x + self.width * 1.5);
        animation.removedOnCompletion = false;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [animation animationStop:^(CAAnimation *anim, BOOL finished) {
            if (completeRemoved ) {
                [weakSelf removeFromSuperview];
            }
        }];
    }];
}



-(void) setCornerWithRadius:(CGFloat) radius{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = true;
}
-(void) setCornerToCircle{
    CGFloat radius = self.bounds.size.width/2;
    [self setCornerWithRadius:radius];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(UINavigationController * ) navigationController{
    UIViewController * vc = [self viewController];
    while (vc && [vc isKindOfClass:[UINavigationController class]] == false) {
        vc = [vc.view.superview viewController];
    }
    return (UINavigationController *)vc;
}

-(UITabBarController * ) tabBarController{
    UIViewController * vc = [self viewController];
    while (vc && [vc isKindOfClass:[UITabBarController class]] == false) {
        vc = [vc.view.superview viewController];
    }
    return (UITabBarController *)vc;
}
// 进度 圆弧 百分比遮罩
-(void) arcProgressWithPercentage:(CGFloat) percentage{
    CAShapeLayer * mask = [self addArcProgressMaskLayer];//添加遮罩layer
    mask.path = [self getArcProgerssPathWithProgress:percentage].CGPath; //添加路径
}

-(CAShapeLayer * ) addArcProgressMaskLayer{
    static CAShapeLayer * mask ; //保证只会被添加一次
    if (!mask) {
        mask = [[CAShapeLayer alloc] init];
        mask.fillRule = kCAFillRuleEvenOdd;
        mask.lineWidth = 0.001;
        self.layer.mask = mask;
    }
    return mask;
}

-(UIBezierPath *) getArcProgerssPathWithProgress:(CGFloat) percentage{
    UIBezierPath * path = [[UIBezierPath alloc] init];
    CGSize size = self.frame.size;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = M_PI * 2 * percentage + startAngle;
    CGPoint center = CGPointMake(size.width/2, size.height/2);
    [path addArcWithCenter:center radius:size.width/2 startAngle:startAngle endAngle: endAngle clockwise:true];
    [path addLineToPoint:center];
    return path;
}
/**
 *  生命周期构造
 */
+(void)load{
    [UIView swizingMethod];
}
static char FirstEnterKey;
-(NSNumber *)firstEnter{
    return objc_getAssociatedObject(self, &FirstEnterKey);
}

-(void)setFirstEnter:(NSNumber *)firstEnter{
    objc_setAssociatedObject(self, &FirstEnterKey, firstEnter, OBJC_ASSOCIATION_RETAIN);
}

+(void) swizingMethod{
    GCDExecOnce(^{
        //        [self swizzleSelector:@selector(layoutSubviews) withSelector:@selector(layoutSubviews_Ext)];
        [self swizzleSelector:@selector(layoutSublayersOfLayer:) withSelector:@selector(layoutSublayersOfLayer_Ext:)];
        [self swizzleSelector:@selector(addSubview:) withSelector:@selector(addSubview_Ext:)];
        [self swizzleSelector:@selector(removeFromSuperview) withSelector:@selector(removeFromSuperview_Ext)];
        [self swizzleSelector:@selector(pointInside:withEvent:) withSelector:@selector(pointInside_Ext:withEvent:)];
        [self swizzleSelector:@selector(bringSubviewToFront:) withSelector:@selector(bringSubviewToFront_Ext:)];
    })
}


-(void)layoutSublayersOfLayer_Ext:(CALayer *)layer{
    if ([self.firstEnter boolValue] == false) {
        self.firstEnter = [NSNumber numberWithBool:true];
        [self onEnter];
    }
    if (self.nextLoopCallback) {
        self.nextLoopCallback();
        self.nextLoopCallback = nil;
    }
    [self layoutSublayersOfLayer_Ext:layer];
}

//-(void)layoutSubviews_Ext{
//
//    [self layoutSubviews_Ext];
//}

-(void)addSubview_Ext:(UIView *)view{
    self.exclusiveTouch = true;// 防止多个按钮 同时按  同时回调点击事件
    [self addSubview_Ext:view];
    [view setNeedsLayout];
    if ([self.viewDelegate respondsToSelector:@selector(view:didAddSubview:)]) {
        [self.viewDelegate view:self didAddSubview:view];
    }
}

-(instancetype)initWithFrame_Ext:(CGRect)frame{
    self = [self initWithFrame_Ext:frame];
    //[self initSelf];
    return self;
}

-(void)removeFromSuperview_Ext{
    [self onExit];
    [self removeFromSuperview_Ext];
}

//下一帧调用 用来初始化一些数据
-(void) onEnter{
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor redColor].CGColor;
}
//离开父亲
-(void) onExit{
    //self.firstEnter = nil;
}


-(void) hideSubViews{
    for (UIView * sub in self.subviews) {
        sub.hidden = true;
    }
}

-(void) showSubViews{
    for (UIView * sub in self.subviews) {
        sub.hidden = false;
    }
}

-(UITapGestureRecognizer *) addTapGestureRecognizerWithTarget:(id)target action:(SEL) action{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    self.userInteractionEnabled = true;
    [self addGestureRecognizer:tap];
    return tap;
}

-(UIPanGestureRecognizer *) addPanGestureRecognizerWithTarget:(id)target action:(SEL) action{
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    self.userInteractionEnabled = true;
    [self addGestureRecognizer:pan];
    return pan;
};

-(UIPinchGestureRecognizer *) addPinchGestureRecognizerWithTarget:(id)target action:(SEL) action{
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:target action:action];
    self.userInteractionEnabled = true;
    [self addGestureRecognizer:pinch];
    return pinch;
};

-(UISwipeGestureRecognizer *) addSwipeGestureRecognizerWithTarget:(id)target action:(SEL) action{
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    self.userInteractionEnabled = true;
    [self addGestureRecognizer:swipe];
    return swipe;
};

-(UIRotationGestureRecognizer *) addRotationGestureRecognizerWithTarget:(id)target action:(SEL) action{
    UIRotationGestureRecognizer * rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:target action:action];
    self.userInteractionEnabled = true;
    [self addGestureRecognizer:rotation];
    return rotation;
};

-(UILongPressGestureRecognizer *) addLongPressGestureRecognizerWithTarget:(id)target action:(SEL) action{
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    self.userInteractionEnabled = true;
    [self addGestureRecognizer:longPress];
    return longPress;
};


//将UIView转成UIImage
-(UIImage *)getImageFromView:(UIView *)theView
{
    [theView setNeedsLayout];
    [theView layoutIfNeeded];
    [theView setNeedsDisplay];
    //UIGraphicsBeginImageContext(theView.bounds.size);
    CGSize size = CGSizeMake(theView.bounds.size.width  , theView.bounds.size.height  );
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(UIImage * ) getImage{
    return [self getImageFromView:self];
}
// Duplicate UIView
- (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

-(UIView *)copySelf{
    return  [self duplicate:self];
}

-(BOOL)pointInside_Ext:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [self pointInside_Ext:point withEvent:event];
    if (objc_getAssociatedObject(self, &TouchFrameAddEdgeKey) != nil) {
        UIEdgeInsets edge = self.touchFrameAddEdge;
        CGRect newBound = CGRectMake(self.bounds.origin.x -edge.left, self.bounds.origin.y - edge.top, self.bounds.size.width + edge.left + edge.right, self.bounds.size.height + edge.top + edge.bottom);
        result = CGRectContainsPoint(newBound, point);
    }
    if ([self.viewDelegate respondsToSelector:@selector(view:pointInSide:withEvent:)]) {
        result = [self.viewDelegate view:self pointInSide:point withEvent:event];
    }
    return result;
}

/**
 *  view代理
 */
static char ViewDelegateKey;
-(id<UIViewDelegate>)viewDelegate{
    return objc_getAssociatedObject(self, &ViewDelegateKey);
}

-(void)setViewDelegate:(id<UIViewDelegate>)viewDelegate{
    objc_setAssociatedObject(self, &ViewDelegateKey, viewDelegate,OBJC_ASSOCIATION_ASSIGN);
}

-(NSUInteger)getSubviewIndex{
    return [self.superview.subviews indexOfObject:self];
}

-(void)bringToFront{
    [self.superview bringSubviewToFront:self];
}

-(void)bringSubviewToFront_Ext:(UIView *)view{
    [self bringSubviewToFront_Ext:view];
    if ([self.viewDelegate respondsToSelector:@selector(view:didBringSubViewToFront:)]) {
        [self.viewDelegate view:self didBringSubViewToFront:view];
    }
}

-(void)sendToBack{
    [self.superview sendSubviewToBack:self];
}

-(void)bringOneLevelUp{
    NSUInteger currentIndex = [self getSubviewIndex];
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex+1];
}

-(void)sendOneLevelDown{
    NSUInteger currentIndex = [self getSubviewIndex];
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex-1];
}

-(BOOL)isInFront
{
    return ([self.superview.subviews lastObject]==self);
}

-(BOOL)isAtBack{
    return ([self.superview.subviews objectAtIndex:0]==self);
}

-(void)swapDepthsWithView:(UIView*)swapView{
    [self.superview exchangeSubviewAtIndex:[self getSubviewIndex] withSubviewAtIndex:[swapView getSubviewIndex]];
}

static char NextLoopCallbackKey;

-(VoidClorse)nextLoopCallback{
    return objc_getAssociatedObject(self, &NextLoopCallbackKey);
}

-(void)setNextLoopCallback:(VoidClorse)nextLoopCallback{
    objc_setAssociatedObject(self, &NextLoopCallbackKey, nextLoopCallback, OBJC_ASSOCIATION_COPY);
}

-(void) performInNextLoopWithBlock:(VoidClorse) block{
    self.nextLoopCallback = nil;
    self.nextLoopCallback = block;
    [self setNeedsLayout];
}

/**
 *  刷新布局
 */
-(void) refreshLayout{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void) scaleFrameOfSubviewsWithScale:(CGFloat)scale{
    for (UIView * sub in self.subviews) {
        CGRect frame = sub.frame;
        frame = CGRectMake(frame.origin.x * scale, frame.origin.y * scale, frame.size.width * scale, frame.size.height * scale);
        sub.frame = frame;
        [sub addConstraintWithFrame:frame];
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)sub;
            NSString * fontName = label.font.fontName;
            CGFloat pointSize = label.font.pointSize;
            label.font = [UIFont fontWithName:fontName size:pointSize * scale];
        }else if([sub isKindOfClass:[UIButton class]]){
            UIButton * button  = (UIButton *)sub;
            NSString * fontName = button.titleLabel.font.fontName;
            CGFloat pointSize = button.titleLabel.font.pointSize;
            button.titleLabel.font = [UIFont fontWithName:fontName size:pointSize * scale];
        }else {
            [sub scaleFrameOfSubviewsWithScale:scale];
        }
    }
}

-(void) scaleCenterOfSubviewsWithXScale:(CGFloat)xScale yScale:(CGFloat) yScale{
    for (UIView * sub in self.subviews) {
        CGRect frame = sub.frame;
        frame = CGRectMake(frame.origin.x * xScale, frame.origin.y * yScale, frame.size.width , frame.size.height );
        sub.frame = frame;
        [sub addConstraintWithFrame:frame];
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)sub;
            NSString * fontName = label.font.fontName;
            CGFloat pointSize = label.font.pointSize;
            label.font = [UIFont fontWithName:fontName size:pointSize * xScale];
        }else if([sub isKindOfClass:[UIButton class]]){
            UIButton * button  = (UIButton *)sub;
            NSString * fontName = button.titleLabel.font.fontName;
            CGFloat pointSize = button.titleLabel.font.pointSize;
            button.titleLabel.font = [UIFont fontWithName:fontName size:pointSize * xScale];
        }else {
            [sub scaleCenterOfSubviewsWithXScale:xScale yScale:yScale];
        }
    }
}



+(instancetype) createFromXib{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil                                                               options:nil];
    return  [nibContents objectAtIndex:0];
}

-(void) addConstraintWithFrame:(CGRect) frame{
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.superview).offset(frame.origin.x);
        make.top.equalTo(self.superview).offset(frame.origin.y);
        make.width.mas_equalTo(frame.size.width);
        make.height.mas_equalTo(frame.size.height);
    }];
}

-(void) animateWithFromScale:(CGFloat)from toScale:(CGFloat)to{
    [self.layer addSpringAnimation:KeyPathTypeTransformScale WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(from);
        animation.toValue = @(to);
        animation.damping = 100;
    }];
}
-(void) animateWithFromScale:(CGFloat)from toScale:(CGFloat)to damp:(CGFloat) damp{
    [self.layer addSpringAnimation:KeyPathTypeTransformScale WithBlock:^(QLXSpringAnimation *animation) {
        animation.fromValue = @(from);
        animation.toValue = @(to);
        if (damp) {
            animation.damping = damp;
        }
    }];
}

-(void)  setBackgroundWithImage:(UIImage *)image{
    UIImageView * iv = [UIImageView createWithImage:image];
    [self addSubview:iv];
    [iv sendToBack];
    iv.contentMode = UIViewContentModeScaleToFill;
    [iv constraintWithEdgeZero];
}

-(void) removeAllSubivews{
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
}

-(void)setScale:(CGFloat)scale{
    self.transform = CGAffineTransformMakeScale(scale, scale);
}

-(void)setRotation:(CGFloat)angle{
    self.transform = CGAffineTransformMakeRotation(angle);
}


// 增加触摸区域
static char TouchFrameAddEdgeKey;

-(UIEdgeInsets)touchFrameAddEdge{
    NSValue * value = objc_getAssociatedObject(self, &TouchFrameAddEdgeKey);
    if (value) {
        return [value UIEdgeInsetsValue];
    }
    return UIEdgeInsetsZero;
}

-(void)setTouchFrameAddEdge:(UIEdgeInsets)touchFrameAddEdge{
    NSValue * value = [NSValue valueWithUIEdgeInsets:touchFrameAddEdge];
    objc_setAssociatedObject(self, &TouchFrameAddEdgeKey, value, OBJC_ASSOCIATION_RETAIN);
}

@end
