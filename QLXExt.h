//
//  QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <Foundation/Foundation.h>
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "YXGCD.h"

// qlx
#import "QLXSpringAnimation.h"
#import "QLXTableView.h"
#import "NSFileManager+QLXExt.h"
#import "QLXRadioGroup.h"
#import "QLXTextField.h"
#import "QLXKeyboard.h"
#import "QLXTextView.h"
#import "QLXViewController.h"
#import "QLXKeyframeAnimation.h"
#import "QLXBasicAnimation.h"
#import "QLXLabel.h"
#import "QLXView.h"
#import "QLXWebView.h"
#import "QLXWeakBlock.h"
#import "QLXNotificationCenter.h"
#import "QLXNavigationController.h"
#import "QLXTableViewController.h"
#import "QLXPageViewController.h"
#import "QLXCollectionView.h"
#import "QLXSegmentControl.h"
#import "QLXObject.h"
#import "QLXPageViewController.h"
#import "QLXWebView.h"
#import "QLXTempRetainManager.h"
#import "QLXNavigationBar.h"
#import "QLXTimer.h"
#import "QLXPageView.h"
#import "QLXVCTransitionAnimatorBase.h"
#import "QLXVCTransitionPushAnimator.h"
#import "QLXCustomerCells.h"
#import "QLXCollectionView.h"
#import "QLXTimer.h"
#import "QLXPageView.h"
#import "QLXSegmentControl.h"
#import "QLXPageViewController.h"
#import "QLXSegmentItem.h"
#import "QLXSegmentItemData.h"
#import "TablePageDataBase.h"
#import "QLXPageViewCell.h"
#import "QLXShapeLayer.h"
#import "QLXTableViewPage.h"
#import "QLXScrollView.h"
#import "QLXButton.h"
#import "QLXAnimationGroup.h"
#import "QLXSlider.h"
#import "QLXTabBarController.h"
#import "QLXAdPageView.h"
#import "QLXTarbarVCTransitionPaddingAnimator.h"
#import "QLXPanGestureRecognizer.h"
#import "QLXHttpRequestTool.h"
#import "QLXCollectionViewHorizalScaleLayout.h"
#import "QLXSideSlipController.h"
#import "QLXScaleView.h"
#import "QLXCollectionViewController.h"
#import "QLXImageView.h"
#import "QLXNoviceGuideBaseView.h"
#import "QLXPopView.h"
#import "QLXHorizalRefreshFooter.h"
#import "QLXHorizalRefreshHeader.h"
#import "QLXCollectionViewFlowLayout.h"

// ext
#import "UIImageView+QLXExt.h"
#import "UIColor+QLXExt.h"
#import "UIView+QLXExt.h"
#import "UIButton+QLXExt.h"
#import "NSObject+QLXExt.h"
#import "UIImage+QLXExt.h"
#import "UIViewController+QLXExt.h"
#import "CALayer+QLXExt.h"
#import "UIApplication+QLXExt.h"
#import "NSString+QLXExt.h"
#import "UIViewController+QLXExt.h"
#import "UIScrollView+QLXExt.h"
#import "UINavigationBar+QLXExt.h"
#import "NSDate+QLXExt.h"
#import "NSDictonary+QLXExt.h"
#import "UINavigationController+QLXExt.h"
#import "UITabBarItem+QLXExt.h"


//ref
#import "QLXHttpModel.h"
#import "PageBaseParam.h"
#import "PageBaseResult.h"
#import "BaseParam.h"

#import "PageBaseResult.h"
#define kAnimtationDuration 0.3
#define kBlockWeakSelf __weak typeof(&*self) weakSelf = self
#define kBlockStrongSelf __strong typeof(&*weakSelf) strongSelf = weakSelf

// 打印常用信息
#define logFunc      NSLog(@"%s",__FUNCTION__);

#define logView(view)   NSLog(@"%@",(view));

#define logFrame(view)    NSLog(@"%s frame %lf , %lf , %lf , %lf" ,__FUNCTION__ ,view.frame.origin.x , view.frame.origin.y , view.frame.size.width , view.frame.size.height);

// 运行时objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define msgTarget(target) (__bridge void *)(target)

// RGB颜色
#define QLXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//颜色和透明度设置
#define QLXColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define QLXHexColor(hexStr)      ([UIColor colorWithHexString:hexStr])
// RGB颜色
#define MJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
//
#define  kAutoScreenWidth(value) ((value) * [UIView scaleX])

#define  kAutoScreenHeight(value) ((value) * [UIView scaleY])



// 单例定义

#define singleInstanceDefine \
+(instancetype) getInstance;\
\
+(void) destoryInstance;


// 单例实现

#define singleInstanceImple \
static id instance;\
+(instancetype) getInstance{ \
\
@synchronized(self) {\
if (instance == nil) {  \
instance = [self new]; \
}\
}\
return instance;\
}\
\
+(void) destoryInstance{\
instance = nil;\
}



