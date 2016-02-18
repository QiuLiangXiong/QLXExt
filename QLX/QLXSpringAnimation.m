//
//  QLXSpringAnimation.m
//  testQLXExt
//
//  Created by 邱良雄 on 15/8/15.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXSpringAnimation.h"

@implementation QLXSpringAnimation
-(void)animationDidStart:(CAAnimation *)anim{
    if (self.animationEnd == nil) {
        self.delegate = nil;
    }
    if (self.animationStart) {
        self.animationStart(self);
        self.animationStart = nil;
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.delegate = nil;
    if (self.animationEnd) {
        self.animationEnd((QLXSpringAnimation *)anim,flag);
        self.animationEnd = nil;
    }
}

-(void) animationStart:(AnimationStartClorce) startClock{
    self.animationStart = startClock;
    self.delegate = self;
}
-(void) animationStop:(AnimationEndClorce) endClock{
    self.animationEnd = endClock;
    self.delegate = self;
}


+ (instancetype)animationWithKeyPathType:(KeyPathType) type {
    NSString * path = [ QLXSpringAnimation getStringWithKeyPathType:type];
    return [super animationWithKeyPath:path];
}

+(NSString *)getStringWithKeyPathType:(KeyPathType) type{
    switch (type) {
        case KeyPathTypePositionX:
            return @"position.x";
        case KeyPathTypePositionY:
            return @"position.y";
        case KeyPathTypePosition:
            return @"position";
        case KeyPathTypeCornerRadius:
            return @"cornerRadius";
        case KeyPathTypeTransformScale:
            return @"transform.scale";
        case KeyPathTypeTransformRotationZ:
            return @"transform.rotation.z";
        case KeyPathTypeTransformRotationX:
            return @"transform.rotation.x";
        case KeyPathTypeTransformRotationY:
            return @"transform.rotation.y";
        case KeyPathTypeBounds:
            return @"bounds";
        case KeyPathTypeTransform:
            return @"transform";
        case KeyPathTypeOpacity:
            return @"opacity";
        case KeyPathTypeBackgroundColor:
            return @"backgroundColor";
        case KeyPathTypeBorderWidth:
            return @"borderWidth";
        case KeyPathTypeFrame:
            return @"frame";
        case KeyPathTypeHidden:
            return @"hidden";
        case KeyPathTypeMask:
            return @"mask";
        case KeyPathTypeMasksToBounds:
            return @"masksToBounds";
        case KeyPathTypeShadowColor:
            return @"shadowColor";
        case KeyPathTypeShadowOffset:
            return @"shadowOffset";
        case KeyPathTypeShadowOpacity:
            return @"shadowOpacity";
        case KeyPathTypeShadowRadius:
            return @"shadowRadius";
        default:
            break;
    }
    return @"";
}
@end
