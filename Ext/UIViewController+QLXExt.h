//
//  UIViewController+QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/12.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXNavigationBar.h"
#import "UIView+QLXExt.h"
@interface UIViewController(QLXExt)


-(void) presentViewControllerWithClass:(Class) aClass animated:(BOOL) animated completion:(void (^)(void))completion;

-(void) presentViewControllerWithClass:(Class) aClass completion:(void (^)(void))completion;

-(void) presentViewControllerWithClass:(Class) aClass navigationControllerClass:(Class) nClass completion:(void (^)(void))completion;

@end

