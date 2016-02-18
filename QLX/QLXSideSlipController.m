//
//  QLXSideSlipController.m
//  FunPoint
//
//  Created by QLX on 15/12/31.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXSideSlipController.h"
#import "QLXExt.h"

// 矩形位置关系  注： 这里不考虑相切的情况
typedef enum {
    RectanglePostionRelationDeviation,  // 相离
    RectanglePostionRelationintersect,  // 相交
    RectanglePostionRelationinContain   // 包含
} RectanglePostionRelation;



@interface QLXSideSlipController ()<UIViewDelegate , QLXScrollViewDelegate , UIGestureRecognizerDelegate>

@property(nonatomic , strong)  UIViewController * leftController; //  左控制器
@property(nonatomic , strong)  UIViewController * rightController;  // 右控制器
@property(nonatomic , strong)  UIViewController * mainController;   // 主控制器

@property(nonatomic , strong)  UIView * leftView;
@property(nonatomic , strong)  UIView * mainView;
@property(nonatomic , strong)  UIView * rightView;

@property(nonatomic , strong)  QLXScrollView * scrollView;
@property(nonatomic , assign) CGFloat pageWidth;

@property(nonatomic , assign) CGFloat mainViewX ;

@property(nonatomic , strong) NSMutableDictionary * controllerLifecycleDic;

@property(nonatomic , assign) BOOL inited;



@end

@implementation QLXSideSlipController

+(instancetype) createWithLeftController:(UIViewController *) left mainController:(UIViewController *) main rightController:(UIViewController *)right{
    return [[self alloc] initWithLeftController:left mainController:main rightController:right];
}

-(instancetype) initWithLeftController:(UIViewController *) left mainController:(UIViewController *) main rightController:(UIViewController *)right{
    self = [self init];
    if (self) {
        self.leftController = left;
        self.rightController = right;
        self.mainController = main;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set ContentSize and Offset
    int numPage = self.leftController == nil ? 1 : 2;
    if (self.leftController) {
        assert(self.leftDivideRatio >= self.rightDivideRatio); //注：leftDivideRatio >= rightDivideRatio
    }
    self.scrollView.contentSize = CGSizeMake(numPage * self.pageWidth + self.view.width * self.rightDivideRatio, self.view.height );
    
    if (self.leftController) {
        self.scrollView.offsetX = self.pageWidth;
    }else {
        [self refreshControllersFrameWithOffset:CGPointZero];
    }
    
    self.leftController.view.userInteractionEnabled = false;
    self.rightController.view.userInteractionEnabled = false;
    self.mainController.view.userInteractionEnabled = true;
    
    self.inited = true;
    
//    [GCDQueue executeInMainQueue:^{
//        [self presentViewController:[UIViewController new] animated:true completion:nil];
//    } afterDelaySecs:2];
//    
//    [GCDQueue executeInMainQueue:^{
//        [self dismissModalViewControllerAnimated:true];
//    } afterDelaySecs:5];
}

-(void) showLeftController{
    if (self.leftController) {
        [self scrollViewWillBeginDragging:self.scrollView];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
}

-(void) showMainController{
    [self scrollViewWillBeginDragging:self.scrollView];
    if (self.leftController) {
        [self.scrollView setContentOffset:CGPointMake(self.pageWidth, 0) animated:true];
    }else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
    }
}

-(void) showRightController{
    if (self.rightController) {
        [self scrollViewWillBeginDragging:self.scrollView];
        if (self.leftController) {
            [self.scrollView setContentOffset:CGPointMake(self.pageWidth + self.view.width * self.rightDivideRatio, 0) animated:true];
        }else {
            [self.scrollView setContentOffset:CGPointMake(self.view.width * self.rightDivideRatio , 0 ) animated:true];
        }
    }
}

-(void) onTapController:(UITapGestureRecognizer *) gesture{
    if (self.leftController && gesture.view == self.leftView  ) {
        [self showLeftController];
    }else if(gesture.view == self.mainView){
        [self showMainController];
    }else if(self.rightController &&  gesture.view == self.rightView){
        [self showRightController];
    }
}



-(UIView *)leftView{
    if (!_leftView && self.leftController) {
        _leftView = [QLXView createWithBgColor:[UIColor clearColor]];
        _leftView.frame = CGRectMake(0, 0, self.view.width * self.leftDivideRatio, self.view.height);
        [_leftView addSubview:self.leftController.view];
        self.leftController.view.frame = _leftView.bounds;
        [self.scrollView addSubview:_leftView];
        
        UIGestureRecognizer * gr = [_leftView addTapGestureRecognizerWithTarget:self action:@selector(onTapController:)];
        gr.delegate = self;
        [self.mainView bringToFront];
    }
    return _leftView;
}

-(UIView *)mainView{
    if (!_mainView) {
        _mainView = [QLXView createWithBgColor:[UIColor clearColor]];
        _mainView.frame = self.view.bounds;
        [_mainView addSubview:self.mainController.view];
        self.mainController.view.frame = self.view.bounds;
        UIGestureRecognizer * gr = [_mainView addTapGestureRecognizerWithTarget:self action:@selector(onTapController:)];
        gr.delegate = self;
        [self.scrollView addSubview:_mainView];
    }
    return _mainView;
}

-(UIView *)rightView{
    if (!_rightView && self.rightController) {
        _rightView = [QLXView createWithBgColor:[UIColor clearColor]];
        _rightView.frame = CGRectMake(0, 0, self.view.width * self.rightDivideRatio, self.view.height);
        [_rightView addSubview:self.rightController.view];
        UIGestureRecognizer * gr = [_rightView addTapGestureRecognizerWithTarget:self action:@selector(onTapController:)];
        gr.delegate = self;
         self.rightController.view.frame = _rightView.bounds;
        [self.scrollView addSubview:_rightView];
        [self.mainView bringToFront];
    }
    return _rightView;
}

-(CGFloat)leftDivideRatio{
    if (self.leftController == nil) {
        return 0;
    }
    if (_leftDivideRatio == 0) {
        return 0.8;
    }
    return _leftDivideRatio;
}


-(CGFloat)rightDivideRatio{
    if (self.rightController == nil) {
        return 0;
    }
    if (_rightDivideRatio == 0) {
        return 0.8;
    }
    return _rightDivideRatio;
}

-(CGFloat)leftSlideLeftScale{
    if (_leftSlideLeftScale == 0) {
        return 0.8;
    }
    return _leftSlideLeftScale;
}

-(CGFloat)leftSlideMainScale{
    if (_leftSlideMainScale == 0) {
        return 0.8;
    }
    return _leftSlideMainScale;
}

-(CGFloat)leftSliderStartRatio{
    if (_leftSliderStartRatio == 0) {
        return 0.5;
    }
    return _leftSliderStartRatio;
}

-(CGFloat)rightSliderStartRatio{
    if (_rightSliderStartRatio == 0) {
        return 0.5;
    }
    return _rightSliderStartRatio;
}

-(CGFloat)rightSlideMainScale{
    if (_rightSlideMainScale == 0) {
        return 0.8;
    }
    return _rightSlideMainScale;
}

-(CGFloat)rightSlideRightScale{
    if (_rightSlideRightScale == 0) {
        return 0.8;
    }
    return _rightSlideRightScale;
}

-(NSMutableDictionary *)controllerLifecycleDic{
    if (!_controllerLifecycleDic) {
        _controllerLifecycleDic = [NSMutableDictionary new];
    }
    return _controllerLifecycleDic;
}


-(CGFloat)pageWidth{
    if (self.leftDivideRatio == 0) {
        return self.view.width;
    }
    return self.view.width * self.leftDivideRatio;
}

-(CGFloat)mainViewX{
    if (_mainViewX == 0) {
        if (self.leftController) {
            _mainViewX = self.pageWidth -(self.view.width - self.pageWidth) / 2;
        }
    }
    return _mainViewX;
}

-(QLXScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [QLXScrollView new];
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        _scrollView.frame = CGRectMake(0, 0, self.pageWidth, self.view.height);
        _scrollView.center = self.view.center;
        _scrollView.pagingEnabled = true;
        _scrollView.bounces = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.viewDelegate = self;
        _scrollView.clipsToBounds = false;
    }
    return _scrollView;
}

-(void) refreshControllersFrameWithOffset:(CGPoint) offset{

        if (self.leftController && offset.x <= self.pageWidth) {
            self.rightView.hidden = true;
            self.leftView.hidden = false;
            CGFloat progress = offset.x / self.pageWidth;
            // mainView
            CGFloat scale = self.leftSlideMainScale + (1 - self.leftSlideMainScale) * progress;
             self.mainView.transform = CGAffineTransformMakeScale(scale, scale);
            self.mainView.x = self.mainViewX;
            // leftView
            scale = self.leftSlideLeftScale +  (1 - self.leftSlideLeftScale) * ( 1 - progress);
            self.leftView.transform = CGAffineTransformMakeScale(scale, scale);
            self.leftView.x = -(self.view.width - self.pageWidth) / 2 + self.pageWidth * self.leftSliderStartRatio * ( progress);
        }else {
            self.leftView.hidden =  true;
            self.rightView.hidden = false;
            CGFloat progress = (offset.x - self.pageWidth ) / (self.view.width * self.rightDivideRatio);
            if (self.leftController == nil) {
                progress = (offset.x ) / (self.view.width * self.rightDivideRatio);
            }
            CGFloat scale = self.rightSlideMainScale + (1 - self.rightSlideMainScale) * (1 - progress);
            // mainView
            self.mainView.transform = CGAffineTransformMakeScale(scale, scale);
            self.mainView.x = self.mainViewX + self.view.width * (1 - scale );
            // rightView
            scale = self.rightSlideRightScale +  (1 - self.rightSlideRightScale) * (  progress);
            self.rightView.transform = CGAffineTransformMakeScale(scale, scale);
            self.rightView.x = (self.mainViewX + self.view.width) - (self.view.width * self.rightDivideRatio * self.rightSliderStartRatio * (1 - progress));
        }
}

#pragma mark - QLXScrollViewDelegate

-(void)scrollView:(UIScrollView *)scrollView oldContentOffset:(CGPoint)oldContentOffset newContentOffset:(CGPoint)newContentOffset{
   
    if (self.inited) {
        RectanglePostionRelation old , new;
        old = [self leftControllerPostionRelationWithContentOffset:oldContentOffset];
        new = [self leftControllerPostionRelationWithContentOffset:newContentOffset];
        [self lifecycleWithController:self.leftController oldRelation:old newRelation:new];
        
        old = [self mainControllerPostionRelationWithContentOffset:oldContentOffset];
        new = [self mainControllerPostionRelationWithContentOffset:newContentOffset];
        [self lifecycleWithController:self.mainController oldRelation:old newRelation:new];
        
        old = [self rightControllerPostionRelationWithContentOffset:oldContentOffset];
        new = [self rightControllerPostionRelationWithContentOffset:newContentOffset];
        [self lifecycleWithController:self.rightController oldRelation:old newRelation:new];
    }
    
    [self refreshControllersFrameWithOffset:newContentOffset];
}

-(void) lifecycleWithController:(UIViewController *) controller oldRelation:(RectanglePostionRelation) old newRelation:(RectanglePostionRelation) new{
    if (!controller) {
        return;
    }
    NSString * key = [controller address];
    NSString * lastState = [self.controllerLifecycleDic objectForKey:key];
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

-(RectanglePostionRelation) leftControllerPostionRelationWithContentOffset:(CGPoint) contentOffset{
    if (self.leftController) {
        if (contentOffset.x < 0.5) {
            return RectanglePostionRelationinContain;
        }else if(contentOffset.x + 0.5 > self.pageWidth){
            return RectanglePostionRelationDeviation;
        }
        return RectanglePostionRelationintersect;
    }
    return RectanglePostionRelationDeviation;
}

-(RectanglePostionRelation) mainControllerPostionRelationWithContentOffset:(CGPoint) contentOffset{
   
    CGFloat offset = self.leftController == nil? 0 : self.pageWidth;
    if (fabs(contentOffset.x -  offset) < 0.5) {
        return  RectanglePostionRelationinContain;
    }else if((self.leftController && contentOffset.x < 0.5)){
        return  RectanglePostionRelationDeviation;
    }else if((contentOffset.x + 0.5 > ( offset + self.view.width * self.rightDivideRatio)) ){
        return  RectanglePostionRelationDeviation;
    }
    return RectanglePostionRelationintersect;
}

-(RectanglePostionRelation) rightControllerPostionRelationWithContentOffset:(CGPoint) contentOffset{
    CGFloat offset = self.leftController == nil ? 0 : self.pageWidth;
    if (fabs(contentOffset.x - ( offset + self.view.width * self.rightDivideRatio)) < 0.5) {
        return RectanglePostionRelationinContain;
    }else if(contentOffset.x < offset + 0.5){
        return RectanglePostionRelationDeviation;
    }
    return RectanglePostionRelationintersect;
}



-(BOOL)scrollView:(UIScrollView *)scrollView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([self.delegate respondsToSelector:@selector(sideSlipController:gestureRecognizerShouldBegin:)]) {
        return [self.delegate sideSlipController:self gestureRecognizerShouldBegin:gestureRecognizer];
    }
    BOOL result = true;
    if (self.leftController) {
        result = [self isAppearedWithController:self.leftController];
    }
    if (result && self.rightController) {
        result = [self isAppearedWithController:self.rightController];
    }
    if (result && self.mainController) {
        result = [self isAppearedWithController:self.mainController];
    }
    return result;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.leftController.view.userInteractionEnabled = false;
    self.mainController.view.userInteractionEnabled = false;
    self.rightController.view.userInteractionEnabled = false;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        CGFloat offsetX = scrollView.offsetX;
    if (self.leftController) {
        if (fabs(offsetX) < 1) {
            self.leftController.view.userInteractionEnabled = true;
        }else if(fabs(offsetX - self.pageWidth) < 1){
            self.mainController.view.userInteractionEnabled = true;
        }else {
            self.rightController.view.userInteractionEnabled = true;
        }
    }else {
        if (fabs(offsetX) < 1) {
           self.mainController.view.userInteractionEnabled = true;
        }else {
            self.rightController.view.userInteractionEnabled = true;
        }
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

-(SideSlipState)state{
    if (self.leftController.view.userInteractionEnabled) {
        return SideSlipStateLefted;
    }
    if (self.rightController.view.userInteractionEnabled) {
        return SideSlipStateRighted;
    }
    if (self.mainController.view.userInteractionEnabled) {
        return SideSlipStateMained;
    }
    return SideSlipStateSliding;
}


#pragma mark - UIViewDelegate

-(BOOL)view:(UIView *)view pointInSide:(CGPoint)point withEvent:(UIEvent *)event{
    point = [view convertPoint:point toView:view.superview];
    return CGRectContainsPoint(self.view.bounds, point);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self selectedController] viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self selectedController] viewWillDisappear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[[self selectedController] viewDidAppear:animated]; // 系统会自动搞到为子controller 分配该事件
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[self selectedController] viewDidDisappear:animated];
}


-(BOOL) isAppearedWithController:(UIViewController *) rootViewController{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self isAppearedWithController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return navigationController.viewControllers.count <= 1 && navigationController.presentedViewController == nil;
    } else if (rootViewController.presentedViewController) {
        return false;
    }
    else {
        return true;
    }
}

-(UIViewController *) selectedController{
    if (self.leftController.view.userInteractionEnabled) {
        return self.leftController;
    }else if(self.leftController.view.userInteractionEnabled){
        return self.rightController;
    }else if(self.mainController.view.userInteractionEnabled){
        return self.mainController;
    }
    return nil;
}

#pragma mark - UIGestreuRecinzerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UITapGestureRecognizer * tapGR = (UITapGestureRecognizer *)gestureRecognizer;
    if (tapGR.view == self.mainView) {
        return !self.mainController.view.userInteractionEnabled;
    }
    return false;
}



@end
