//
//  TableViewHeaderFooterLableView.h
//  QLXExtDemo
//
//  Created by QLX on 15/11/5.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXTableViewHeaderFooterView.h"

@class  QLXLabel;

@interface TableViewHeaderFooterLableView : QLXTableViewHeaderFooterView

@property(nonatomic , strong) QLXLabel * titleLbl;

@property(nonatomic , assign) CGFloat  headerFooterHeight;

-(void) setTitle:(NSString *)title hexColor:(NSString *)cStr fontSize:(CGFloat )size height:(CGFloat) height;

@end
