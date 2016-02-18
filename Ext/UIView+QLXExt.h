//
//  UIView+QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kW(value) ([UIView scaleX]*(value))
#define kH(value) ([UIView scaleY]*(value))
#define kH2(value,value2) ( kH((value) + (value2)) - value2)

@protocol UIViewDelegate <NSObject>
@optional
/**
 *   添加子view后 提醒
 *
 *  @param view    父亲
 *  @param subView 孩纸
 */
-(void) view:(UIView *)view didAddSubview:(UIView *)subView;

/**
 *  是否向下分发触摸的点
 */
-(BOOL) view:(UIView *)view pointInSide:(CGPoint) point withEvent:(UIEvent *)event;
/**
 *  调用了self BringSubViewToFront 会回调这个代理
 */
-(void) view:(UIView *) superView didBringSubViewToFront:(UIView *)view;

@end

typedef void (^VoidClorse)();

@interface UIView (QLXExt)

@property (nonatomic, strong) NSNumber * firstEnter;
@property (nonatomic, weak)id<UIViewDelegate> viewDelegate;
@property (nonatomic, copy) VoidClorse nextLoopCallback;
@property(nonatomic , assign) UIEdgeInsets  touchFrameAddEdge;   // 扩增view的触摸区域  该原来frame基础上增加edge
/**
 *  frame ext
 */
- (CGFloat)width;

- (void)setWidth:(CGFloat)width;

- (CGFloat)height;

- (void)setHeight:(CGFloat)height;

- (CGPoint)leftTop;

- (void)setLeftTop:(CGPoint)leftTop;

- (CGPoint)rightBottom;

- (void)setRightBottom:(CGPoint)rightBottom;

- (void)setLeft:(CGFloat)left;

- (CGFloat)left;

- (void)setRight:(CGFloat)right;

- (CGFloat)right;

- (void)setX:(CGFloat)x;

- (CGFloat)x;

- (void)setY:(CGFloat)y;

- (CGFloat)y;

- (void)setCenterX:(CGFloat)centerX;

- (CGFloat)centerX;

- (void)setCenterY:(CGFloat)centerY;

- (CGFloat)centerY;

- (void)setSize:(CGSize)size;

- (CGSize)size;
/**
 *  auto layout
 *
 */
/**
 *  非父亲视图 上间隔 和 居中间隔 宽度 高度
 *
 *  @param toView  toView description
 *  @param top     top description
 *  @param centerX centerX description
 *  @param width   width description
 *  @param height  height description
 */
-(void) constraintWithEqual:(UIView *)toView top:(CGFloat) top centerX:(CGFloat) centerX width:(CGFloat)width height:(CGFloat)height;
/**
 *
 *  父亲视图 上间隔 和 居中间隔 宽度 高度
 *  @param top     top description
 *  @param centerX centerX description
 *  @param width   width description
 *  @param height  height description
 */
-(void) constraintWithTop:(CGFloat) top centerX:(CGFloat) centerX width:(CGFloat)width height:(CGFloat)height;
/**
 *  非父亲视图 上间隔 和 居中间隔
 *
 *  @param toView  toView description
 *  @param top     top description
 *  @param centerX centerX description
 *  @param width   width description
 *  @param height  height description
 */
-(void) constraintWithEqual:(UIView *)toView top:(CGFloat) top centerX:(CGFloat) centerX ;
/**
 *
 *  父亲视图 上间隔 和 居中间隔
 *  @param top     top description
 *  @param centerX centerX description
 *  @param width   width description
 *  @param height  height description
 */
-(void) constraintWithTop:(CGFloat) top centerX:(CGFloat) centerX ;

-(void) constraintWithEdgeZero;

-(void) constraintWithEdge:(UIEdgeInsets) edge;

-(void) remakeConstraintWithEdge:(UIEdgeInsets) edge;

-(void) constraintWithEdgeZeroWithView:(UIView *) view;

-(void) updateTopWithOffset:(CGFloat) offset;

-(void) updateLeftWithOffset:(CGFloat) offset;

-(void) updateBottomWithOffset:(CGFloat) offset;

-(void) updateRightWithOffset:(CGFloat) offset;
/**
 *  根据屏幕的不同 返回iphone6 和 其他屏幕的宽度比例
 */
+(CGFloat) scaleX;
/**
 *  根据屏幕的不同 返回iphone6 和 其他屏幕的宽度比例
 *
 */
+(CGFloat) scaleY;
/**
 *  获得自动布局后的自己的frameSize
 *
 */
-(CGSize) getLayoutSize;

/**
 *  动画
 *
 */
-(void) animateWithShakeWithDuration:(CGFloat) duration force:(CGFloat) force ;

-(void) animateWithShake;

-(void) animateFromBootomToShow;

-(void) animateFromBootomToHidden:(BOOL) completeRemoved;

-(void) animateFromRightToShow;

-(void) animateFromRightToHiden:(BOOL) completeRemoved;

-(void) setCornerWithRadius:(CGFloat) radius;

-(void) setCornerToCircle;
/**
 *  获取当前view的控制主视图
 *
 */
- (UIViewController *)viewController;
/**
 *  圆弧 百分比 遮罩
 *
 *  @param percentage 进度  [0,1]
 */

-(UINavigationController * ) navigationController;

-(UITabBarController * ) tabBarController;

-(void) arcProgressWithPercentage:(CGFloat) percentage;


/**
 *  当view 进入到"屏幕"后调用
 *  或者可以理解为 下一帧调用
 */
-(void) onEnter;

/**
 *  当view 离开"屏幕"后调用
 *  注意: 可能多次调用
 */
-(void) onExit;
/**
 *  隐藏所有子视图
 */
-(void) hideSubViews;

-(void) showSubViews;
/**
 *  添加单击手势
 *  它自动帮你交互属性设置为true
 *  @param target
 *  @param action
 */
-(UITapGestureRecognizer *) addTapGestureRecognizerWithTarget:(id)target action:(SEL) action;

/**
 *  摇动或者拖拽UIPanGestureRecognizer (拖动)
 *
 *  @param target
 *  @param action
 */
-(UIPanGestureRecognizer *) addPanGestureRecognizerWithTarget:(id)target action:(SEL) action;
/**
 *  擦碰UISwipeGestureRecognizer (以任意方向)
 *
 *  @param target
 *  @param action
 */
-(UISwipeGestureRecognizer *) addSwipeGestureRecognizerWithTarget:(id)target action:(SEL) action;

/**
 *  旋转UIRotationGestureRecognizer (手指朝相反方向移动)
 *
 *  @param target
 *  @param action
 */
-(UIRotationGestureRecognizer *) addRotationGestureRecognizerWithTarget:(id)target action:(SEL) action;
/**
 *  长按UILongPressGestureRecognizer (长按)
 *
 *  @param target
 *  @param action
 */
-(UILongPressGestureRecognizer *) addLongPressGestureRecognizerWithTarget:(id)target action:(SEL) action;
/**
 *  向里或向外捏UIPinchGestureRecognizer (用于缩放)
 *
 *  @param target
 *  @param action
 */
-(UIPinchGestureRecognizer *) addPinchGestureRecognizerWithTarget:(id)target action:(SEL) action;

+(void) swizingMethod;

/**
 *  将view 渲染成 一张 图片
 *
 *  @return imageSize == view.bounds.size
 */
-(UIImage * ) getImage;
/**
 *  完全复制自己
 *
 *  @return
 */
-(UIView *)copySelf;

/**
 *  z_order
 *  调整 层级 扩展
 *  @return
 */
-(NSUInteger)getSubviewIndex;

-(void)bringToFront;

-(void)sendToBack;

-(void)bringOneLevelUp;

-(void)sendOneLevelDown;

-(BOOL)isInFront;

-(BOOL)isAtBack;

-(void)swapDepthsWithView:(UIView*)swapView;

/**
 *  下一个runloop 调用
 *
 *  @param block 闭包
 */

-(void) performInNextLoopWithBlock:(VoidClorse) block;


/**
 *  刷新布局
 */
-(void) refreshLayout;

/**
 *  缩放视图 相当于整体视图缩放 subview 还会递归下去
 *
 *  @param scale 缩放比例
 */
-(void) scaleFrameOfSubviewsWithScale:(CGFloat)scale;
/**
 *  缩放视图的中心点  用来适配视图大小不变 位置按照原来的百分比来放
 *
 *  @param xScale 横向缩放系数
 *  @param yScale 纵向缩放系数
 */
-(void) scaleCenterOfSubviewsWithXScale:(CGFloat)xScale yScale:(CGFloat) yScale;

+(instancetype) createFromXib;

// 添加约束 frame
-(void) addConstraintWithFrame:(CGRect) frame;

-(void) animateWithFromScale:(CGFloat)from toScale:(CGFloat)to;

-(void) animateWithFromScale:(CGFloat)from toScale:(CGFloat)to damp:(CGFloat) damp;

/**
 *  设置背景
 *
 *  @param image
 */

-(void)  setBackgroundWithImage:(UIImage *)image;;

/**
 *  删除所有子视图
 */
-(void) removeAllSubivews;

/**
 *  设置视图的缩放系数
 *  沿着视图的中心点缩放 缩放的还是可以交互 交互的范围会适应比例变化
 *  @param scale [ 0  , 1]
 */
-(void) setScale:(CGFloat) scale ;


/**
 *  设置视图的旋转角度
 *  沿着视图的中心点旋转
 *  M_PI_4  表示顺时针旋转45度
 */

-(void) setRotation:(CGFloat)angle;

@end
