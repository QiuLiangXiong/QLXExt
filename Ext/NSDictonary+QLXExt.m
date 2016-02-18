//
//  NSDictonary+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/23.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "NSDictonary+QLXExt.h"
#import "QLXExt.h"
@implementation NSDictionary(QLXExt)


- (NSString*)dictionaryToJson{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&parseError];
    
    if (parseError) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

-(NSMutableDictionary *) mutableDictionary{
    return [[NSMutableDictionary alloc] initWithDictionary:self];
}
@end
