//
//  NSObject+QLXExt.m
//  
//
//  Created by QLX on 15/8/9.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import "NSObject+QLXExt.h"
#import "QLXExt.h"
#import  <objc/runtime.h>

@implementation NSObject(QLXExt)

@dynamic dellocObjcet;

-(NSString *) hashString{
    return [NSString stringWithFormat:@"%lu",(unsigned long)[self hash]];
}
-(NSString *) address{
    return [NSString stringWithFormat:@"%ld",(long)self];
}

+(NSString *) addressWithObject:(id) object{
    return [NSString stringWithFormat:@"%ld",(long)object];
}

-(NSString *) className{
    return [NSString stringWithUTF8String:object_getClassName(self)];
}

-(Class) getClass{
    return self.class;
}

+(id) createWithClass:(Class) aClass{
    return [[aClass alloc] init];
}

-(instancetype) toSelf{
    return self;
}

+(instancetype) toSelfWithObject:(id)obj{
    return obj;
}


-(void) saveData{
    [GCDQueue executeInGlobalQueue:^{
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archvier = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archvier encodeObject:self forKey:[self fileName]];
        [archvier finishEncoding];
        [data writeToFile:[self getFilePath] atomically:true];
    }];
}

+(instancetype) getData{
    id instance ;
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:[self getFilePath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    instance = [unarchiver decodeObjectForKey:[self fileName]];
    [unarchiver finishDecoding];
    return instance;
}

-(NSString *) getFilePath{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return  [[paths objectAtIndex:0] stringByAppendingPathComponent:[self fileName]];
}

-(NSString * ) fileName{
    return [[self className] stringByAppendingString:@"_code.archiver"];
}

-(void) saveDataWithFileName:(NSString *)fileName{
    [GCDQueue executeInGlobalQueue:^{
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archvier = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archvier encodeObject:self forKey:fileName];
        [archvier finishEncoding];
        [data writeToFile:[self getFilePathWithFileName:fileName] atomically:true];
    }];
}

+(instancetype) getDataWithFileName:(NSString *)fileName{
    id instance ;
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:[self getFilePathWithFileName:fileName]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    instance = [unarchiver decodeObjectForKey:fileName];
    [unarchiver finishDecoding];
    return instance;
}


-(NSString *) getFilePathWithFileName:(NSString *)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return  [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
}



-(void) update{
}

-(void) starUpdateWithIntervalTime:(NSTimeInterval) duration{
    [QLXTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(update) userInfo:nil nowStart:false];
}

// 获取当前显示的 viewController
- (UIViewController*)getCurrentVC {
    return [self topViewControllerWithRootViewController:[self getRootViewController]];
}

-(UIViewController *) getRootViewController{
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows){
            if (topWindow.windowLevel == UIWindowLevelNormal){
                break;
            }
        }
    }
    return topWindow.rootViewController;
}
- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else {
        return rootViewController;
    }
}

-(UIWindow *) getWindow{
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows){
            if (topWindow.windowLevel == UIWindowLevelNormal){
                break;
            }
        }
    }
    return topWindow;
}




+ (void)swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethodInit=class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethodInit) {
        class_addMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static char DellocObjectKey;
-(QLXObject *)dellocObjcet{
    QLXObject * objcet = objc_getAssociatedObject(self, &DellocObjectKey);
    if (!objcet) {
        objcet = [QLXObject new];
        objcet.obj = [self address];
        objc_setAssociatedObject(self, &DellocObjectKey, objcet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objcet;
}

-(void)setDellocObjcet:(QLXObject *)dellocObjcet{
    objc_setAssociatedObject(self, &DellocObjectKey, dellocObjcet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) performBlockOnDeallocWithTarget:(id)target block:(IDBlock) block{
    [self.dellocObjcet addBlockWithTarget:target block:block];
}

-(void) logRetainCount{
    NSLog(@"%@ Retain count is %ld",[self className], CFGetRetainCount((__bridge CFTypeRef)self));
}

-(NSString *)  getDocumentPathWithFileName:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (fileName == nil) {
        fileName = @"";
    }
    return  [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
}
@end
