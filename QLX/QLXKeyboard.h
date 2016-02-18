//
//  QLXKeyboard.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/15.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
typedef void(^KeyboardBlock)(CGFloat addHeight ,CGFloat height , CGFloat duration);
@interface QLXKeyboard : NSObject
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, assign , getter=isShowKeyboard) BOOL showKeyboard;
@property (nonatomic, copy) KeyboardBlock keyboardWillShowBlock;
@property (nonatomic, copy) KeyboardBlock keyboardWillHideBlock;
@property (nonatomic, strong) NSMutableDictionary *  keyboardWillShowBlockDic;
@property (nonatomic, strong) NSMutableDictionary * keyboardWillHideBlockDic;

+(QLXKeyboard *) getInstance;

-(void) addKeyboardWillHideBlock:(KeyboardBlock) block;

-(void) addKeyboardWillShowBlock:(KeyboardBlock) block;

-(void) removeBlock;

-(void) addKeyboardWillShowBlockWithTarget:(id) target  block:(KeyboardBlock) block;

-(void) addKeyboardWillHideBlockWithTarget:(id) target  block:(KeyboardBlock) block;

-(void) removeBlockWithTarget:(id) target;

@end
