//
//  NSString+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/15.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "NSString+QLXExt.h"

@implementation NSString(QLXExt)

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *) string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    if (string == nil || [string isEqualToString:@""]) {
        string = @"yyyy-MM-dd HH:mm:ss";
    }
    [dateFormatter setDateFormat:string];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}



- (NSDate *)dateFromString:(NSString *)dateString format:(NSString *) string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (string == nil || [string isEqualToString:@""]) {
        string = @"yyyy-MM-dd HH:mm:ss";
    }
    [dateFormatter setDateFormat: string];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//Base64字符串转UIImage图片：
+(UIImage *) convertToImageWithBase64String:(NSString *) string{
    NSData *decodedImageData = [[NSData alloc]
                                initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return  [UIImage imageWithData:decodedImageData];
}


-(UIImage *) base64StringConvertToImage{
    return [NSString convertToImageWithBase64String:self];
}

-(NSDictionary * ) jsonToDictionary{
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        result = nil;
    }
    return result;
}


-(BOOL) isUrl{
    return [NSURL URLWithString:self] && (
           [self hasPrefix:@"http://"] ||
           [self hasPrefix:@"https://"]) ;

}

-(const char *)  toCString{
    return [self cStringUsingEncoding:(NSASCIIStringEncoding)];
}

@end
