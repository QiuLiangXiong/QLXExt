//
//  UIViewController+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/12.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "UIViewController+QLXExt.h"
#import "QLXExt.h"

@interface UIViewController()
@end
@implementation UIViewController(QLXExt)

+(void)load{
    GCDExecOnce(^{
        [self swizzleSelector:@selector(viewDidAppear:) withSelector:@selector(viewDidAppear_Ext:)];
    })
}



-(void)viewDidAppear_Ext:(BOOL)animated{
    [self viewDidAppear_Ext:animated];
   // NSLog(@"%@",[self className]);
}

-(void) presentViewControllerWithClass:(Class) aClass animated:(BOOL) animated completion:(void (^)(void))completion{
    UIViewController * vc = [aClass new];
    [self presentViewController:vc animated:animated completion:completion];
}

-(void) presentViewControllerWithClass:(Class) aClass completion:(void (^)(void))completion{
    [self presentViewControllerWithClass:aClass animated:true completion:completion];
}

-(void) presentViewControllerWithClass:(Class) aClass navigationControllerClass:(Class) nClass completion:(void (^)(void))completion{
    UINavigationController * naVC = [[nClass alloc] initWithRootViewController:[aClass new]];
    [self presentViewController:naVC animated:true completion:completion];
}





//-(BOOL)view:(UIView *)view pointInSide:(CGPoint)point{
//    QLXNavigationBar * bar = objc_getAssociatedObject(self, &NavigationBarKey);
//    if (view == self.view && bar) {
//        if (CGRectContainsPoint(self.navigationBar.frame, point)) {
//            return true;
//        }
//    }
//    return false;
//}










@end
