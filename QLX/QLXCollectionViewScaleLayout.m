//
//  QLXCollectionViewScaleLayout.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/11/18.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import "QLXCollectionViewScaleLayout.h"
#import "QLXExt.h"


#define scale self.minScale

@interface QLXCollectionViewScaleLayout()

@property (nonatomic, strong) NSMutableArray * attributesArray;
@property (nonatomic, assign) BOOL setItemSized;
@property (nonatomic, assign) BOOL setHeaderSized;
@property (nonatomic, assign) BOOL setFooterSized;

@end

@implementation QLXCollectionViewScaleLayout

-(CGSize)collectionViewContentSize{
    NSInteger num = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(self.collectionView.width , self.headerReferenceSize.height + num * self.itemSize.height + (self.collectionView.height - self.itemSize.height) + 1);
}

-(void)prepareLayout{
    [super prepareLayout];
    NSMutableArray * array = [NSMutableArray new];
    // cell
    NSArray * cells = [self getCellAttributes];
    [array addObjectsFromArray:cells];
    // header
    UICollectionViewLayoutAttributes * header = [self getHeaderAttribute];
    if (header) {
        [array addObject:header];
    }
    //  footer
    UICollectionViewLayoutAttributes * footer = [self getFooterAttribute];
    if (footer) {
        [array addObject:footer];
    }
    self.attributesArray = array;
}

// cell attribute

-(NSArray *) getCellAttributes{
    NSMutableArray * array = [NSMutableArray new];
    NSInteger num =  [self.collectionView numberOfItemsInSection:0];
    CGFloat offsetY = self.collectionView.offsetY  - self.headerReferenceSize.height;
    offsetY = fmax(offsetY, 0);
    int index = (int)(offsetY / self.itemSize.height);
    int total = (int)(self.collectionView.height / (self.itemSize.height * scale)) + 1;
    // cell
    for (int i = index ; i < num && i < (index + total) ; i++) {
        [array addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
    }
    return array;
}

-(UICollectionViewLayoutAttributes *) getHeaderAttribute{
    // 头部
    if (self.headerReferenceSize.height != 0) {
        UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        attribute.frame = CGRectMake(0, 0, self.headerReferenceSize.width, self.headerReferenceSize.height);
        return attribute;
    }
    return nil;
}

-(UICollectionViewLayoutAttributes *) getFooterAttribute{
    // 尾部
    if (self.footerReferenceSize.height != 0) {
        NSInteger num = [self.collectionView numberOfItemsInSection:0];
        UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        CGRect frame = [self getFrameWithRow:num ];
        frame.size = self.footerReferenceSize;
        attribute.frame = frame;
        attribute.zIndex = num;
        return attribute;
    }
    return nil;
}
// 每次布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return true;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.frame = [self getFrameWithRow:indexPath.row];
    attribute.zIndex = indexPath.row;
    return attribute;
}

-(CGRect) getFrameWithRow:(NSInteger) row{
    CGRect frame;
    CGFloat offsetY = self.collectionView.offsetY  - self.headerReferenceSize.height;
    offsetY = fmax(offsetY, 0);
    int index = (int)(offsetY / self.itemSize.height);
    CGFloat remain = offsetY - ( self.itemSize.height * index);
    CGFloat ratio = remain / self.itemSize.height;
    CGFloat postionY = fmax(self.collectionView.offsetY, 0) + (self.itemSize.height - remain);
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    if (row == index + 1) {
        frame = CGRectMake(0, postionY, self.itemSize.width, self.itemSize.height);
        [self sendScaleDelegateWithIndexPath:indexPath withScale:scale + (1-scale) * ratio];
    }else if(row > index + 1){
        CGFloat y = postionY + ( self.itemSize.height * scale * (row - index - 1)+ self.itemSize.height * (1 - scale) * ratio);
        frame = CGRectMake(0, y, self.itemSize.width, self.itemSize.height);
        [self sendScaleDelegateWithIndexPath:indexPath withScale:scale];
    }else {
        CGFloat y = postionY - (self.itemSize.height * scale * (index + 1 - row) + self.itemSize.height * (1 - scale) * (1-ratio));
        frame = CGRectMake(0, y, self.itemSize.width, self.itemSize.height);
        [self sendScaleDelegateWithIndexPath:indexPath withScale:1];
    }
    return frame;
}

// 发送 缩放信息 代理
-(void) sendScaleDelegateWithIndexPath:(NSIndexPath *)indexPath withScale:(CGFloat) aScale{
    NSInteger num = [self.collectionView numberOfItemsInSection:0];
    if (indexPath.row < num && [self.delegate respondsToSelector:@selector(collctionViewLayout:indexPath:withScale:)]) {
        [self.delegate collctionViewLayout:self indexPath:indexPath withScale:aScale];
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributesArray;
}


// 吸附
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGPoint point = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    CGFloat offsetY = point.y  - self.headerReferenceSize.height;
    offsetY = fmax(offsetY, 0);
    int index = (int)(offsetY / self.itemSize.height);
    CGFloat remain = offsetY - ( self.itemSize.height * index);
    
    if (remain > self.itemSize.height * 0.5) {
        return CGPointMake(0, point.y + self.itemSize.height - remain);
    }else {
        return CGPointMake(0, point.y  - remain);
    }
    return point;
}

-(CGSize)headerReferenceSize{
    CGSize size = [super headerReferenceSize];
    if (self.setHeaderSized == false) {
        self.setHeaderSized = true;
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            id<UICollectionViewDelegateFlowLayout>  delegate = ( id<UICollectionViewDelegateFlowLayout> ) self.collectionView.delegate;
           size = [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:0];
            [super setHeaderReferenceSize:size];
        }
    }
    return size;
}

-(void)setHeaderReferenceSize:(CGSize)headerReferenceSize{
    [super setHeaderReferenceSize:headerReferenceSize];
    self.setHeaderSized = true;
}


-(CGSize)footerReferenceSize{
    CGSize size = [super footerReferenceSize];
    if (self.setFooterSized == false) {
        self.setFooterSized = true;
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            id<UICollectionViewDelegateFlowLayout>  delegate = ( id<UICollectionViewDelegateFlowLayout> ) self.collectionView.delegate;
            size = [delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:0];
            [super setFooterReferenceSize:size];
        }
    }
    return size;
}

-(void)setFooterReferenceSize:(CGSize)footerReferenceSize{
    [super setFooterReferenceSize:footerReferenceSize];
    self.setFooterSized = true;
}


-(CGSize)itemSize{
    CGSize size = [super itemSize];
    if (self.setItemSized == false) {

        NSInteger  num = [self.collectionView numberOfItemsInSection:0];
        if (num > 0) {
            self.setItemSized = true;
            if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
                id<UICollectionViewDelegateFlowLayout>  delegate = ( id<UICollectionViewDelegateFlowLayout> ) self.collectionView.delegate;
                size = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [super setItemSize:size];
            }
        }
    }
    return size;
}

-(void)setItemSize:(CGSize)itemSize{
    [super setItemSize:itemSize];
    self.setItemSized = true;
}


-(id<QLXCollectionViewScaleLayoutDelegate>)delegate{
    if (!_delegate) {
        _delegate = (id<QLXCollectionViewScaleLayoutDelegate>)self.collectionView.delegate;
    }
    return _delegate;
}


-(CGFloat)minScale{
    if (_minScale == 0) {
        return 0.45;
    }
    return _minScale;
}
@end
