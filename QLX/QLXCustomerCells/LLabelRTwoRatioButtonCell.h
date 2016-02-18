//
//  LLabelRTwoRatioButtonCell.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/12.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXTableViewCell.h"
#import "QLXLabel.h"
#import "QLXRadioGroup.h"
@interface LLabelRTwoRatioButtonCell : QLXTableViewCell
@property (nonatomic, strong) QLXLabel * leftLbl;
@property (nonatomic, strong) QLXRadioGroup * rightRG;
-(void) setContentWithLeftStr:(NSString*) left selectedIndex:(NSInteger) index ;
@end
