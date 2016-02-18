//
//  NSFileManager+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/12/1.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "NSFileManager+QLXExt.h"

@implementation NSFileManager(QLXExt)


+(NSString *)  getDocumentPath{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
   
}

+(NSString *)  getDocumentPathWithFileName:(NSString *)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (fileName == nil ) {
        return [paths objectAtIndex:0];
    }
    return  [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
}
                
+(NSMutableArray *) getFilePathsWithSuffix:(NSString *) suffix atDirectionPath:(NSString *)path{
    NSError * error;
    if (![path hasSuffix:@"/"]) {
        path = [path stringByAppendingString:@"/"];
    }
    NSMutableArray * filePaths = [NSMutableArray new];
    NSArray * fileArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:&error];
    if (!error) {
        for (NSString * filePath in fileArray) {
            if ([filePath isKindOfClass:[NSString class]]) {
                if ([filePath hasSuffix:suffix]) {
                    NSString  * fullPath = [path stringByAppendingString:filePath];
                    [filePaths addObject:fullPath];
                }
            }else {
                assert(0); //
            }
        }
    }else {
        NSLog(@"%s %@",__FUNCTION__ ,error.domain);
    }
    return filePaths;
}

@end
