//
//  QLXSideSlipController.h
//  侧滑 像QQ那样侧滑的效果
//
//  Created by QLX on 15/12/31.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXViewController.h"
#import "UIKit/UIKit.h"

typedef enum {
    SideSlipStateMained,  // 侧滑到了正视图（控制器maincontroller）
    SideSlipStateLefted,  // 侧滑到了左视图（控制器controller）
    SideSlipStateRighted, // 侧滑到了右视图（控制器controller）
    SideSlipStateSliding , // 侧滑中
}SideSlipState;           // 侧滑状态

@protocol QLXSideSlipControllerDelegate;

@interface QLXSideSlipController : QLXViewController


@property(nonatomic , weak) id<QLXSideSlipControllerDelegate> delegate;

//注：leftDivideRatio >= rightDivideRatio  
@property(nonatomic , assign) CGFloat leftDivideRatio;// 左控制器和主控制器的划分比例 默认0.8
@property(nonatomic , assign) CGFloat rightDivideRatio;// 右控制器和主控制器的划分比例 默认0.8

@property(nonatomic , assign) CGFloat leftSlideLeftScale;  // 右拖拉左视图时 左视图的缩放最小值  默认0.8
@property(nonatomic , assign) CGFloat leftSlideMainScale;  // 右拖拉左视图时 主视图的缩放最小值  默认0.8
@property(nonatomic , assign) CGFloat leftSliderStartRatio; //右拖拉左视图时 左视图起始比例     默认0.5

@property(nonatomic , assign) CGFloat rightSlideRightScale;  // 左拖拉右视图时 右视图的缩放最小值 默认0.8
@property(nonatomic , assign) CGFloat rightSlideMainScale;   // 左拖拉右视图时 主视图的缩放最小值 默认0.8
@property(nonatomic , assign) CGFloat rightSliderStartRatio; // 左拖拉右视图时 右视图视图起始比例 默认0.5

@property(nonatomic , assign , readonly)  SideSlipState state;//侧滑状态

/**
 *  类构造方法
 *
 *  @param left  左边控制器
 *  @param main  主控制器 在中间
 *  @param right 右边控制器
 *
 *  @return  侧滑控制器对象
 */
+(instancetype) createWithLeftController:(UIViewController *) left mainController:(UIViewController *) main rightController:(UIViewController *)right;

-(instancetype) initWithLeftController:(UIViewController *) left mainController:(UIViewController *) main rightController:(UIViewController *)right;

// 显示左控制器

-(void) showLeftController;

// 显示主控制器

-(void) showMainController;

// 显示右控制器

-(void) showRightController;


@end

@protocol QLXSideSlipControllerDelegate <NSObject>


-(BOOL) sideSlipController:(QLXSideSlipController *) controller  gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;


@end
