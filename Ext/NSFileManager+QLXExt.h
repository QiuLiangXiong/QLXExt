//
//  NSFileManager+QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/12/1.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager(QLXExt)

/**
 *  获得沙盒文件路径
 *
 *  @param fileName 文件名
 *
 *  @return 全路径
 */
+(NSString *)  getDocumentPathWithFileName:(NSString *)fileName;

/**
 *  获得沙盒文件根路径
 *
 *  @return 全路径
 */
+(NSString *)  getDocumentPath;

/**
 *  获取某个路径下的所有后缀为指定后缀的文件路径的数组
 *
 *  @param suffix 文件后缀
 *  @param path   某个路径下
 *
 *  @return 目标文件全路径数组
 */
+(NSMutableArray *) getFilePathsWithSuffix:(NSString *) suffix atDirectionPath:(NSString *)path;


@end
