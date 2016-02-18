//
//  QLXPageViewCell.h
//  QLXExtDemo
//
//  Created by QLX on 15/10/30.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXCollectionViewCell.h"

@protocol QLXPageViewCellDelegate ;

@interface QLXPageViewCell : QLXCollectionViewCell

@end

@protocol QLXPageViewCellDelegate <QLXCollectionViewCellDelegate>

@optional

@end
