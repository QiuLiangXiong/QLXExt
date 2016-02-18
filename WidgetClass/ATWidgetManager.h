//
//  ATWidgetManager.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/27.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@class ATWidgetController;
@class ATTableWidgetView;
@interface ATWidgetManager : NSObject

+(instancetype) getInstance;

/**
 *  注册拉
 *
 *  @param controller table 所在的controller
 *  @param table
 */
-(void) registerTableWidgetViewWithController:(UIViewController *) controller tableWidgeView:(ATTableWidgetView *)table;

-(ATTableWidgetView * ) getTableWidgetViewWithControllerClass:(Class) aClass;

@end
