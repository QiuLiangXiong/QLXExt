//
//  QLXAnimationGroup.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/11/6.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXAnimationGroup.h"

@implementation QLXAnimationGroup

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
        self.animationEnd(anim,flag);
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


@end
