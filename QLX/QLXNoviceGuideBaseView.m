//
//  QLXNoviceGuideBaseView.m
//  fcuhConsumer
//
//  Created by QLX on 16/1/23.
//  Copyright © 2016年 avatar. All rights reserved.
//

#import "QLXNoviceGuideBaseView.h"
#import "QLXExt.h"

@implementation QLXNoviceGuideBaseView

+(void) showInView:(UIView *) view key:(NSString *) key{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        [[NSUserDefaults standardUserDefaults] setObject:@(true) forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIView *  rootView = [self new];
        [QLXPopView popWithRootView:rootView inView:view withPopStyle:(QLXPopStyleFade) makeRootViewFrameWithBlock:^(UIView *rootView, UIView *superview) {
            [rootView constraintWithEdgeZero];
        }];
    }
}

-(void)onEnter{
    [super onEnter];
    [self addTapGestureRecognizerWithTarget:self action:@selector(onTapGesture:)];
}

-(void) onTapGesture:(UITapGestureRecognizer *) gesture{
    [QLXPopView closeWithRootView:self animated:true];
}

@end
