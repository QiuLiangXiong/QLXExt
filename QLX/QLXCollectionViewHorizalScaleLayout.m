//
//  QLXCollectionViewHorizalScaleLayout.m
//  写得我快吐血  吐血  .....  烧脑 烧脑 你懂吗？？？？？？？？？？
//
//  Created by QLX on 15/12/22.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXCollectionViewHorizalScaleLayout.h"
#import "QLXExt.h"

@interface QLXCollectionViewHorizalScaleLayout()<QLXCollectionViewCellDelegate , UIViewDelegate>

@property (nonatomic, assign) BOOL setItemSized;
@property(nonatomic , assign) NSInteger numOfItem;
@property(nonatomic , strong)  NSMutableArray * attributesArray;
@property(nonatomic , assign) CGFloat margin ;
@property(nonatomic , assign) CGFloat pageWidth;
@property(nonatomic , assign) CGFloat orginCollectionViewWidth;
@property(nonatomic , assign) CGFloat scaleOffset;

@end


@implementation QLXCollectionViewHorizalScaleLayout



-(NSInteger)numOfItem{
    if ([self.collectionView numberOfSections] > 0) {
        return [self.collectionView numberOfItemsInSection:0];
    }
    return 0;
}

-(CGFloat)itemSpace{
    if (_itemSpace == 0) {
        _itemSpace = 15;
    }
    if (self.pagingEnable) {
        return -(fabs(2 * self.margin)) ;
    }
    return _itemSpace;
}

-(CGFloat)scale{
    if (_scale == 0) {
        _scale = 0.5;
    }
    return _scale;
}

-(CGSize)collectionViewContentSize{
    if (self.pagingEnable) {
        self.collectionView.clipsToBounds = false;
        self.collectionView.pagingEnabled = true;
        self.collectionView.viewDelegate = self;
        if ([self.collectionView isKindOfClass:[QLXCollectionView class]]) {
            QLXCollectionView * collectionView = (QLXCollectionView *)self.collectionView;
            collectionView.cellDelegate = self;
        }
    }
    
    NSInteger num = self.numOfItem;
    CGFloat width = self.collectionView.width + (num-1) * (self.itemSize.width + self.itemSpace);
    return CGSizeMake(width, self.collectionView.height);
}

-(void)prepareLayout{
    [super prepareLayout];
    NSMutableArray * array = [NSMutableArray new];
    // cell
    NSArray * cells = [self getCellAttributes];
    [array addObjectsFromArray:cells];
    self.attributesArray = array;
}

-(NSArray *) getCellAttributes{
    NSMutableArray * array = [NSMutableArray new];
    NSInteger num =  self.numOfItem;
    CGFloat offsetX = self.collectionView.offsetX ;
    offsetX = fmax(offsetX, 0);
    int index = offsetX / self.pageWidth;
    if (index > 0) {
        index--;
    }
    // cell
    for (int i = index ; i < num && i < (index + 4) ; i++) {
        [array addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
    }
    return array;
}

// 每次布局都重新布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return true;
}


// 发送 缩放信息 代理
-(void) sendScaleDelegateWithIndexPath:(NSIndexPath *)indexPath withScale:(CGFloat) aScale{
    NSInteger num = self.numOfItem;
    if (indexPath.row < num && [self.delegate respondsToSelector:@selector(collctionViewLayout:indexPath:withScale:)]) {
        [self.delegate collctionViewLayout:self indexPath:indexPath withScale:aScale];
    }
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect frame;
    NSInteger row = indexPath.row;
    CGFloat offsetX = self.collectionView.offsetX;
    CGFloat itemSpaceToEdge = (self.collectionView.width - self.itemSize.width) /  2;
    int index = offsetX / self.pageWidth;
    CGFloat remain = offsetX - (self.pageWidth * index);   // 剩余单元偏移量
    CGFloat ratio = remain / self.pageWidth;               // 剩余单元比例
    
    CGFloat pointX = offsetX + self.itemSize.width +  itemSpaceToEdge;
    CGFloat scale = self.scale + (1- self.scale) * (1 - ratio);
    if (scale > 1) {
        scale = 1 - (scale -1);
    }
    CGFloat width = self.itemSize.width * scale;
    // CGFloat height = self.itemSize.height * scale;
    CGFloat x = pointX - width - remain;
    CGFloat y = (self.collectionView.height - self.itemSize.height * scale) / 2;
    
    if (row == index) {          //  当前这一个
        frame = [self getFrameWithX:x  y:y  scale:scale];
        [self sendScaleDelegateWithIndexPath:indexPath withScale:scale];
        attribute.transform = CGAffineTransformMakeScale(scale, scale);
    }else if(row == index + 1){  // 下一个
        CGFloat scale =  self.scale + (1- self.scale) * (ratio);
        CGFloat x1 = x + width + self.itemSpace;
        CGFloat y1 = (self.collectionView.height - self.itemSize.height * scale) / 2;
        
        [self sendScaleDelegateWithIndexPath:indexPath withScale:scale];
        attribute.transform = CGAffineTransformMakeScale(scale, scale);
        frame = [self getFrameWithX:x1  y:y1  scale:scale];
    }else if(row < index){    //  上 ( < last)
        CGFloat scale =  self.scale;
        CGFloat x2 = x - (index - row) * ((self.itemSize.width * scale) + self.itemSpace);
        CGFloat y2 = (self.collectionView.height - self.itemSize.height * scale) / 2;
        
        [self sendScaleDelegateWithIndexPath:indexPath withScale:scale];
        attribute.transform = CGAffineTransformMakeScale(scale, scale);
        frame = [self getFrameWithX:x2  y:y2  scale:scale];
    }else {               //   其他不在屏幕的（ > next）
        CGFloat nextX = x + width + self.itemSpace;
        CGFloat nextWidth =  self.itemSize.width * (self.scale + (1- self.scale) * (ratio));
        CGFloat scale =  self.scale;
        CGFloat x3 = (nextX + nextWidth) +(row - index - 2) * (self.itemSize.width * self.scale + self.itemSpace) + self.itemSpace;
        CGFloat y3 = (self.collectionView.height - self.itemSize.height * scale) / 2;
        [self sendScaleDelegateWithIndexPath:indexPath withScale:scale];
        attribute.transform = CGAffineTransformMakeScale(scale, scale);
        frame = [self getFrameWithX:x3  y:y3  scale:scale];
    }
    attribute.frame = frame;
    return attribute;
}

-(CGRect) getFrameWithX:(CGFloat) x y:(CGFloat) y scale:(CGFloat) scale{
    CGFloat x0 = x - (1 - scale) * self.itemSize.width / 2;
    CGFloat y0 = y - (1 - scale) * self.itemSize.height / 2;
    return CGRectMake(x0,y0 , self.itemSize.width, self.itemSize.height);
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributesArray;
}

-(CGSize)itemSize{
    CGSize size = [super itemSize];
    if (self.setItemSized == false) {
        
        NSInteger  num = self.numOfItem;
        if (num > 0) {
            self.setItemSized = true;
            if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
                id<UICollectionViewDelegateFlowLayout>  delegate = ( id<UICollectionViewDelegateFlowLayout> ) self.collectionView.delegate;
                size = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [super setItemSize:size];
                [self updateCollectionViewWidthWithSize:size];
            }
        }
    }
    
    if (self.pagingEnable) {
        return CGSizeMake(self.collectionView.width +  2 * self.margin , size.height);
    }
    
    return size;
}

-(CGFloat)pageWidth{
    if (self.pagingEnable) {
        return self.collectionView.width;
    }else {
        return self.itemSize.width + self.itemSpace;
    }
    
}


-(void)setItemSize:(CGSize)itemSize{
    [super setItemSize:itemSize];
    if (self.setItemSized == false) {
        [self updateCollectionViewWidthWithSize:itemSize];
    }
    self.setItemSized = true;
}

-(void)  updateCollectionViewWidthWithSize:(CGSize) size{
    if (self.pagingEnable) {
        CGFloat space = _itemSpace;
        if (space == 0) {
            space = 15;
        }
        self.orginCollectionViewWidth = self.collectionView.width;
        
        self.collectionView.width = size.width + space;
        self.collectionView.x += ((self.orginCollectionViewWidth - self.collectionView.width) / 2);
        if (self.collectionView.translatesAutoresizingMaskIntoConstraints == false) {
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(self.collectionView.height));
                make.width.mas_equalTo(@(self.collectionView.width));
                make.left.equalTo(self.collectionView.superview).offset(self.collectionView.x);
                make.top.equalTo(self.collectionView.superview).offset(self.collectionView.y);
            }];
        }
        
    }
}


// 吸附
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGPoint point = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    CGFloat offsetX = point.x;
    offsetX = fmax(offsetX, 0);
    int index = offsetX / self.pageWidth;
    CGFloat remain = offsetX - (self.pageWidth * index);   // 剩余单元偏移量
    if (remain > self.pageWidth * 0.5 ) {
        point.x = point.x + self.pageWidth - remain;
    }else {
        point.x = point.x  - remain;
    }
    point.x = fmin(point.x , (int)([self collectionViewContentSize].width - self.collectionView.width ));
    point.y = 0;
    return point;
}


-(CGFloat)margin{
    if (self.pagingEnable) {
        CGFloat result = ((self.orginCollectionViewWidth - self.collectionView.width) / 2) - fabs(_itemSpace / 2);
        if (result < 0 ) {
            result = 0;
        }
        return result;
        
    }
    return 0;
}


-(void)initToConfigtWithCollectionViewCell:(QLXCollectionViewCell *)cell{
    if (self.pagingEnable) {
        CGFloat margin = self.margin + _itemSpace / 2 ;
        margin += (margin * ( 1- self.scale) ) ;  // 边缘一丢丢会不见了
        [cell.view remakeConstraintWithEdge:UIEdgeInsetsMake(0, margin , 0, margin )];
    }
}


-(BOOL)view:(UIView *)view pointInSide:(CGPoint)point withEvent:(UIEvent *)event{
    point = [self.collectionView convertPoint:point toView:self.collectionView.superview];
    CGRect frame = self.collectionView.frame;
    CGRect rect = CGRectMake(frame.origin.x - (self.orginCollectionViewWidth - frame.size.width) / 2, frame.origin.y, self.orginCollectionViewWidth, frame.size.height);
    return CGRectContainsPoint(rect, point);
}


@end
