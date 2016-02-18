//
//  NSObject+QLXExt.h
//  
//
//  Created by QLX on 15/8/9.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLXObject.h"
#import "UIKit/UIKit.h"
#import "YXGCD.h"

@interface NSObject(QLXExt)

@property (nonatomic, strong) QLXObject * dellocObjcet;

-(NSString *) hashString;
/**
 *  对象地址
 *
 *  @return
 */
-(NSString *) address;

+(NSString *) addressWithObject:(id) object;
/**
 *  类名
 */
-(NSString *) className;

/**
 *  获得对象类型
 */
-(Class) getClass;

/**
 *  根据类名创造对象
 *
 *  @param aClass
 *
 *  @return
 */
+(id) createWithClass:(Class) aClass;

/**
 *  将一个对象的类型自动转换为本质类型
 *
 *  @return Self 类型对象
 */
-(instancetype) toSelf;

+(instancetype) toSelfWithObject:(id)obj;

/**
 *  归档 单例数据
 */
-(void) saveData;
/**
 *  结档
 *
 *  @return 单例数据
 */
+(instancetype) getData;

/**
 *  结档文件路径
 *
 *  @return
 */

-(NSString *) getFilePath;

/**
 *  结档文件名
 *
 *  @return 
 */
-(NSString * ) fileName;
/**
 *  归档 自定义归档文件名  从而你可以归档多个对象
 *
 *  @param fileName 比如@"test.dat"
 */
-(void) saveDataWithFileName:(NSString *)fileName;
/**
 *  结档  同上
 *
 *  @param fileName
 *
 *  @return
 */
+(instancetype) getDataWithFileName:(NSString *)fileName;
/**
 *  定时更新回调
 */
-(void) update;

/**
 *  开启更新回调
 *
 *  @param duration 更新周期 (每隔多少时间回调一次)
 */
-(void) starUpdateWithIntervalTime:(NSTimeInterval) duration;

/**
 * 获取当前屏幕显示的viewcontroller
 *  @param UIViewController
 *
 *  @return
 */

- (UIViewController *)getCurrentVC;

/**
 *  获得程序的 根viewcontroler
 *
 *  @return 
 */
-(UIViewController *) getRootViewController;

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

/**
 *  获得属于主程序的window
 *
 *  @return
 */
-(UIWindow *) getWindow;
/**
 *  交换方法
 *
 *  @param originalSelector old
 *  @param swizzledSelector new
 */
+ (void)swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector;
/**
 *  死亡闭包 self 死亡时候前回调
 *
 *  @param target
 *  @param block
 */
-(void) performBlockOnDeallocWithTarget:(id)target block:(IDBlock) block;
/**
 *  打印当前对象引用次数
 */
-(void) logRetainCount;


/**
 *  获得沙盒文件路径
 *
 *  @param fileName 文件名
 *
 *  @return <#return value description#>
 */
-(NSString *)  getDocumentPathWithFileName:(NSString *)fileName;

@end
