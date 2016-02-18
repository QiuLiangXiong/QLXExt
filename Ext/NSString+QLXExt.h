//
//  NSString+QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/15.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
@interface NSString(QLXExt)
/**
 *
 *
 *  @param NSString @"yyyy-MM-dd HH:mm:ss zzz" //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息
 *
 *  @return
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *) string;

//输入的日期字符串形如：@"1992-05-21 13:08:08"

- (NSDate *)dateFromString:(NSString *)dateString format:(NSString *) string;

/**
 *  Base64字符串转UIImage图片
 *
 *  @param UIImage
 *
 *  @return 图片
 */
+(UIImage *) convertToImageWithBase64String:(NSString *) string;


-(UIImage *) base64StringConvertToImage;

/**
 *  把json字符串 转换为字典
 *
 *  @return 字典
 */
-(NSDictionary * ) jsonToDictionary;


/**
 *  是否为合法url
 *
 *  @return 
 */
-(BOOL) isUrl;

-(const char *)  toCString;
@end
