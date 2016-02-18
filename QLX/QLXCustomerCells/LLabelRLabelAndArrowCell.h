//
//  LLabelRLabelAndArrowCell.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/12.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXTableViewCell.h"
#import "QLXExt.h"
@interface LLabelRLabelAndArrowCell : QLXTableViewCell
@property (nonatomic, strong) QLXLabel * leftLbl;
@property (nonatomic, strong) QLXLabel * rightLbl;
@property (nonatomic, strong) UIImageView * arrowIV;
-(void) setContentWithLeftStr:(NSString*) left rigthtStr:(NSString *) right;
@end
