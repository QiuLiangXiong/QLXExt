//
//  QLXWeakBlock.h
//
//
//  Created by QLX on 15/9/20.
//  Copyright (c) 2015年 QLX. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol QLXWeakBlockDelegate;
@interface QLXWeakBlock : NSObject
@property(nonatomic , weak) id target;
@property(nonatomic , copy) id block;
@property(nonatomic , weak) id otherInfo;
@property(nonatomic , weak) id<QLXWeakBlockDelegate> delegate;
@property(nonatomic , copy) NSString * targetKey;
@end

@protocol QLXWeakBlockDelegate <NSObject>
@optional
-(void) targetDelloc:(QLXWeakBlock *)block;

@end
