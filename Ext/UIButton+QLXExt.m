//
//  UIButton+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "UIButton+QLXExt.h"
#import "QLXExt.h"
@implementation UIButton(QLXExt)
@dynamic actionBlocks;

+(instancetype) createWithFrame:(CGRect) frame{
    return  [[self alloc] initWithFrame:frame];
}

+(instancetype) create{
    
    return  [self buttonWithType:(UIButtonTypeCustom)];
}

+(instancetype) createWithText:(NSString *)text{
    UIButton * button = [self create];
    [button setTitle:text forState:(UIControlStateNormal)];
    return button;
}

+(instancetype) createWithText:(NSString *)text font:(UIFont *) font{
    UIButton * button = [self create];
    [button setTitle:text forState:(UIControlStateNormal)];
    [button setTitleFont:font];
    return button;
}

+(instancetype) createWithText:(NSString *)text fontSize:(CGFloat) fontSize{
    return [self createWithText:text font:[UIFont systemFontOfSize:fontSize]];
}

+(instancetype) createWithText:(NSString *)text font:(UIFont *) font normal:(NSString *) normal highlighted:(NSString *) press{
    UIButton * button = [self createWithText:text font:font];
    [button setBackgroundImage:[UIImage imageNamed:normal] forState:(UIControlStateNormal)];
    if (press) {
      [button setBackgroundImage:[UIImage imageNamed:press] forState:(UIControlStateHighlighted)];
    }
    return button;
}

+(instancetype) createWithText:(NSString *)text fontSize:(CGFloat) fontSize normal:(NSString *) normal highlighted:(NSString *) press{
    UIButton * button = [self createWithText:text font:[UIFont systemFontOfSize:fontSize] normal:normal highlighted:press];
    return button;
}

+(instancetype) createWithText:(NSString *)text hexColor:(NSString *)color fontSize:(CGFloat) fontSize{
    UIButton * button = [self createWithText:text fontSize:fontSize];
    [button setTitleColor:[UIColor colorWithHexString:color] forState:(UIControlStateNormal)];
    return button;
}

+(instancetype) createWithText:(NSString *)text hexColor:(NSString *)color fontSize:(CGFloat) fontSize normal:(NSString *) normal highlighted:(NSString *) press{
    UIButton * button = [self createWithText:text font:[UIFont systemFontOfSize:fontSize] normal:normal highlighted:press];
    [button setTitleColor:[UIColor colorWithHexString:color] forState:(UIControlStateNormal)];
    return button;
    
}

-(void)setTitleFont:(UIFont *)titleFont{
    self.titleLabel.font = titleFont;
}

static char ActionBlocksKey;

-(NSMutableArray *)actionBlocks{
    NSMutableArray * ab = objc_getAssociatedObject(self, &ActionBlocksKey);
    if (!ab) {
        ab = [NSMutableArray new];
        self.actionBlocks = ab;
    }
    return ab;
}

-(void)setActionBlocks:(NSMutableArray *)actionBlocks{
    objc_setAssociatedObject(self, &ActionBlocksKey, actionBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) addClickActionBlock:(ButtonActionClorce) block{
    [self.actionBlocks addObject:block];
}


-(void)onEnter{
    [super onEnter];
    [self addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
}




-(void) onClick:(UIButton *)sender{
    for (ButtonActionClorce block in self.actionBlocks) {
        if (block) {
            block(sender);
        }
    }
}



//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    if (self.userInteractionEnabled) {
//       [super touchesBegan:touches withEvent:event];
//    }
//    
//}
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    if (self.userInteractionEnabled) {
//        [super touchesMoved:touches withEvent:event];
//    }
//}
//
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    if (self.userInteractionEnabled) {
//        [super touchesCancelled:touches withEvent:event];
//    }
//       kBlockWeakSelf;
//    [GCDQueue executeInMainQueue:^{
//        NSLog(@"no");
//        self.userInteractionEnabled = true;
//    } afterDelaySecs:0.5];
//}
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    if (self.userInteractionEnabled) {
//        self.userInteractionEnabled = false;
//        kBlockWeakSelf;
//        [GCDQueue executeInMainQueue:^{
//            NSLog(@"no");
//            NSLog(@"%@",[weakSelf address]);
//            self.userInteractionEnabled = true;
//        } afterDelaySecs:0.5];
//        [super touchesEnded:touches withEvent:event];
//        
//        NSLog(@"yesw");
//    
//     
//    }
//    
//}
@end
