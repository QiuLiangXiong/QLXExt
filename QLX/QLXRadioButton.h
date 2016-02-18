//
//  QLXRadioButton.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/12.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QLXRadioButton : UIControl
@property (nonatomic, strong) UILabel * textLbl;
@property (nonatomic, strong) UIButton * radioBtn;
+(QLXRadioButton *) create;

-(instancetype)initWithFrame:(CGRect)frame;

- (instancetype)init;

-(void) initialization;

-(void) setTextColor:(UIColor * ) color;

-(void) setTextFont:(UIFont *) font;

-(void) setText:(NSString *)text;

-(void) setRadioImageWithNomal:(NSString *) normal selected:(NSString *) selected;

-(void) setRadioImageWithNomalImage:(UIImage *) normal selectedImage:(UIImage *) selected;

-(void) onClickRadioButton;

-(void) setSelected;

-(void) setUnselected;

-(void) setRadioBtnSize:(CGSize) size;

@end
