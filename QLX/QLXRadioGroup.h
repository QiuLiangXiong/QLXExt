//
//  QLXRadioGroup.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/12.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXRadioButton.h"
typedef enum{
    LayoutStyleHorizontal,
    LayoutStyleVertical
}LayoutStyle;
@protocol QLXRadioGroupDelegate;
@interface QLXRadioGroup : UIView

@property (nonatomic, weak)   id<QLXRadioGroupDelegate> delegate;
@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) LayoutStyle style;
@property (nonatomic, strong) NSMutableArray * radioButtons;
@property (nonatomic, assign) BOOL bLoad;
@property (nonatomic, assign) BOOL multiSelectEnable;
@property (nonatomic, strong) UIImage * normalImage;
@property (nonatomic, strong) UIImage * selectedImage;
@property (nonatomic, assign) NSInteger selectedIndex;

+(QLXRadioGroup *) createWithStyle:(LayoutStyle) style;

-(void) addRadioButtonsWithButtons:(NSArray *) buttons;

-(void) addRadioButtonWithButton:(QLXRadioButton *) button;

-(void) addRadioButtonWithTexts:(NSArray *) texts;

@end


@protocol QLXRadioGroupDelegate <NSObject>
// 选中情况变化 代理
-(void) valueChanged:(QLXRadioButton *) changedButton;

@end
