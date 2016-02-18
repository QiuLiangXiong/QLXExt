//
//  QLXApplication.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/12/1.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLXExt.h"

@interface QLXApplication : NSObject

@property (nonatomic, copy) NSString * curVersion;
@property (nonatomic, assign) BOOL newVersion;

singleInstanceDefine

@end
