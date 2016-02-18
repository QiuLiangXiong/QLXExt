//
//  QLXCollectionViewFlowLayout.m
//  瀑布流 用法和UICollectionViewFlowLayout 一致
//
//  Created by QLX on 16/1/24.
//  Copyright © 2016年 avatar. All rights reserved.
//

#import "QLXCollectionViewFlowLayout.h"
#import "QLXExt.h"

@interface QLXCollectionViewFlowLayout()<UICollectionViewDelegateFlowLayout>

@property(nonatomic , strong) NSMutableArray * attributesArray;
@property(nonatomic , weak) id<UICollectionViewDelegateFlowLayout> delegate;
@property(nonatomic , assign) CGSize contentSize;
@property(nonatomic , assign) CGRect rect;
@property(nonatomic , strong)  NSMutableArray * attributesArrayInRect;

@property(nonatomic , assign)  BOOL verticalDir;// 是否为纵向布局

@end

@implementation QLXCollectionViewFlowLayout

-(CGSize)collectionViewContentSize{
    return self.contentSize;
}

-(void)prepareLayout{
    [super prepareLayout];
    NSMutableArray * array = [NSMutableArray new];
    CGPoint offset = CGPointZero;
    int  section = (int)[self numOfSection];
    for (int i = 0; i < section; i++) {
        [array addObjectsFromArray:[self getAttributesWithSection:i fromOffset:&offset]];
    }
    
    if (self.verticalDir) {
        self.contentSize = CGSizeMake(self.collectionView.width, offset.y);
    }else {
        self.contentSize = CGSizeMake(offset.x, self.collectionView.height - 1);
    }
    
    
    self.attributesArray = array;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  [super layoutAttributesForItemAtIndexPath:indexPath];
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    self.rect = rect;
    return self.attributesArrayInRect;
}

-(UICollectionViewLayoutAttributes *) getHeaderAttributesForVerticalWithSection:(NSInteger)section fromOffset:(CGPoint *) offset{
    CGSize headerSize = [self headerSizeWithSection:section];
    // 头部
    if (headerSize.height > 0 ) {
        UICollectionViewLayoutAttributes * arrtibute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        arrtibute.frame = CGRectMake(0, (*offset).y, headerSize.width, headerSize.height);
        
        return arrtibute;
    }
    return nil;
}

// 水平布局
-(UICollectionViewLayoutAttributes *) getHeaderAttributesForHorizalWithSection:(NSInteger)section fromOffset:(CGPoint *) offset{
    CGSize headerSize = [self headerSizeWithSection:section];
    // 头部
    if (headerSize.width > 0 ) {
        UICollectionViewLayoutAttributes * arrtibute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        arrtibute.frame = CGRectMake((*offset).x, 0, headerSize.width, headerSize.height);
        
        return arrtibute;
    }
    return nil;
}


-(UICollectionViewLayoutAttributes *) getFooterAttributesForHorizalWithSection:(NSInteger)section fromOffset:(CGPoint *) offset{
    CGSize footerSize = [self footerSizeWithSection:section];
    if (footerSize.width > 0) {
        UICollectionViewLayoutAttributes * arrtibute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        arrtibute.frame = CGRectMake((*offset).x - footerSize.width, 0, footerSize.width, footerSize.height);
        return arrtibute;
    }
    return nil;
}

-(UICollectionViewLayoutAttributes *) getFooterAttributesForVerticalWithSection:(NSInteger)section fromOffset:(CGPoint *) offset{
    CGSize footerSize = [self footerSizeWithSection:section];
    
    if (footerSize.height > 0) {
        UICollectionViewLayoutAttributes * arrtibute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        arrtibute.frame = CGRectMake(0, (*offset).y - footerSize.height, footerSize.width, footerSize.height);
        return arrtibute;
    }
    return nil;
}

-(NSMutableArray * )  getCellsAttributesForVerticalWithSection:(NSInteger )section fromOffset:(CGPoint *)offset{
    CGFloat lineSpace = [self minimumLineSpacingWithSection:section];
    CGFloat itemSpace = [self minimumInteritemSpacingWithSection:section];
    UIEdgeInsets sectionInset = [self sectionInsetWithSecion:section];
    CGSize headerSize = [self headerSizeWithSection:section];
    CGSize footerSize = [self footerSizeWithSection:section];
    NSInteger count = [self numOfItemInSection:section];
    NSMutableArray * array = [NSMutableArray new];
    if (count > 0) {
        // cells
        CGSize itemSize = [self itemSizeWithSection:section row:0];
        CGFloat width = (self.collectionView.width - sectionInset.left - sectionInset.right );
        int rows = (width + itemSpace) / (itemSize.width + itemSpace);
        if (rows > 0) {
            if (rows - 1 >0) {
                itemSpace = (width - itemSize.width * rows) / (rows - 1);
            }else {
                itemSpace = (width - itemSize.width ) / 2;
            }
            CGFloat offsetX = (rows == 1)?(sectionInset.left + itemSpace) : sectionInset.left;
            CGFloat initValue = (*offset).y + headerSize.height + sectionInset.top - lineSpace;
            NSMutableArray * heightArray = [self createArrayWithSize:rows initValue:initValue];
            for (int i = 0 ; i < count; i++) {
                itemSize = [self itemSizeWithSection:section row:i];
                
                CGFloat addHeight = itemSize.height + lineSpace;// 添加了一个cell所在列增加到高度
                // 每次在最低列添加cell
                NSInteger row = [self minHeightInRowWithArray:heightArray];
                CGFloat rowHeight = [self rowHeightWithArray:heightArray index:row];
                
                [self addHeightInArray:heightArray index:row height:addHeight];
                
                UICollectionViewLayoutAttributes * arrtibute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
                CGFloat x = offsetX + (row * (itemSize.width + itemSpace));
                arrtibute.frame = CGRectMake( x, rowHeight + lineSpace, itemSize.width, itemSize.height);
                [array addObject:arrtibute];
            }
            // 维护偏移量
            (*offset).y = [self maxHeightInArray:heightArray] + sectionInset.bottom + footerSize.height ;
        }else {
            assert(0); // itemSize.width过大
        }
    }else{
        // 维护偏移量
        (*offset).y = (*offset).y +  headerSize.height + footerSize.height + sectionInset.top + sectionInset.bottom;
    }
    
    return array;
}

// 水平布局
-(NSMutableArray * )  getCellsAttributesForHorizalWithSection:(NSInteger )section fromOffset:(CGPoint *)offset{
    CGFloat lineSpace = [self minimumLineSpacingWithSection:section];
    CGFloat itemSpace = [self minimumInteritemSpacingWithSection:section];
    UIEdgeInsets sectionInset = [self sectionInsetWithSecion:section];
    CGSize headerSize = [self headerSizeWithSection:section];
    CGSize footerSize = [self footerSizeWithSection:section];
    NSInteger count = [self numOfItemInSection:section];
    NSMutableArray * array = [NSMutableArray new];
    if (count > 0) {
        // cells
        CGSize itemSize = [self itemSizeWithSection:section row:0];
        CGFloat height = (self.collectionView.height - sectionInset.top - sectionInset.bottom );
        int rows = (height + lineSpace) / (itemSize.height + lineSpace);
        if (rows > 0) {
            if (rows - 1 >0) {
                lineSpace = (height - itemSize.height * rows) / (rows - 1);
            }else {
                lineSpace = (height - itemSize.height ) / 2;
            }
            CGFloat offsetY = (rows == 1)?(sectionInset.top + lineSpace) : sectionInset.top;
            CGFloat initValue = (*offset).x + headerSize.width + sectionInset.left - itemSpace;
            NSMutableArray * heightArray = [self createArrayWithSize:rows initValue:initValue];
            for (int i = 0 ; i < count; i++) {
                itemSize = [self itemSizeWithSection:section row:i];
                
                CGFloat addHeight = itemSize.width + itemSpace;// 添加了一个cell所在列增加到高度
                // 每次在最低列添加cell
                NSInteger row = [self minHeightInRowWithArray:heightArray];
                CGFloat rowHeight = [self rowHeightWithArray:heightArray index:row];
                
                [self addHeightInArray:heightArray index:row height:addHeight];
                
                UICollectionViewLayoutAttributes * arrtibute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
                CGFloat y = offsetY + (row * (itemSize.height + lineSpace));
                arrtibute.frame = CGRectMake(rowHeight + itemSpace , y, itemSize.width, itemSize.height);
                [array addObject:arrtibute];
            }
            // 维护偏移量
            (*offset).x = [self maxHeightInArray:heightArray] + sectionInset.right + footerSize.width ;
        }else {
            assert(0); // itemSize.width过大
        }
    }else{
        // 维护偏移量
        (*offset).x = (*offset).x +  headerSize.width + footerSize.width + sectionInset.left + sectionInset.right;
    }
    
    return array;
}


-(NSMutableArray *) getAttributesWithSection:(NSInteger) section fromOffset:(CGPoint *) offset {
    NSMutableArray * attributesArray = [NSMutableArray new];
    // 纵向布局
    if (self.verticalDir) {
        // 头部
        UICollectionViewLayoutAttributes * headerAtt = [self getHeaderAttributesForVerticalWithSection:section fromOffset:offset];
        if (headerAtt) {
            [attributesArray addObject:headerAtt];
        }
        // cells
        NSMutableArray * cellAtts = [self getCellsAttributesForVerticalWithSection:section fromOffset:offset];
        [attributesArray addObjectsFromArray:cellAtts];
        // 尾部
        UICollectionViewLayoutAttributes * footerAtt = [self getFooterAttributesForVerticalWithSection:section fromOffset:offset];
        if (footerAtt) {
            [attributesArray addObject:footerAtt];
        }
    }else {
        // 横向布局
        // 头部
        UICollectionViewLayoutAttributes * headerAtt = [self getHeaderAttributesForHorizalWithSection:section fromOffset:offset];
        if (headerAtt) {
            [attributesArray addObject:headerAtt];
        }
        // cells
        NSMutableArray * cellAtts = [self getCellsAttributesForHorizalWithSection:section fromOffset:offset];
        [attributesArray addObjectsFromArray:cellAtts];
        // 尾部
        UICollectionViewLayoutAttributes * footerAtt = [self getFooterAttributesForHorizalWithSection:section fromOffset:offset];
        if (footerAtt) {
            [attributesArray addObject:footerAtt];
        }
    }
    return attributesArray;
}




-(NSInteger) numOfSection{
    if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        return [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    return 0;
}

-(NSInteger ) numOfItemInSection:(NSInteger) section{
    if (section < [self numOfSection]) {
        if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            return [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        }
    }
    return 0;
}

-(CGFloat)minimumLineSpacingWithSection:(NSInteger) section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return self.minimumLineSpacing;
}

-(CGFloat)minimumInteritemSpacingWithSection:(NSInteger) section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return self.minimumInteritemSpacing;
}

-(UIEdgeInsets)sectionInsetWithSecion:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return self.sectionInset;
}

-(CGSize) headerSizeWithSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
    }
    return self.headerReferenceSize;
}

-(CGSize) footerSizeWithSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
    }
    return self.footerReferenceSize;
}

-(CGSize) itemSizeWithSection:(NSInteger) section row:(NSInteger)row{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    return self.itemSize;
}

-(id<UICollectionViewDelegateFlowLayout>)delegate{
    if (!_delegate) {
        _delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.dataSource;
    }
    return _delegate;
}

-(NSMutableArray *) createArrayWithSize:(int) size initValue:(int) value{
    NSMutableArray * array = [NSMutableArray new];
    for (int i = 0 ; i < size ; i++) {
        NSNumber * num = [NSNumber numberWithFloat:value];
        [array addObject:num];
    }
    return array;
}

-(void) addHeightInArray:(NSMutableArray *)array index:(NSInteger)index height:(CGFloat)height{
    NSNumber * num = [array objectAtIndex:index];
    num = [NSNumber numberWithFloat:num.floatValue + height];
    [array replaceObjectAtIndex:index withObject:num];
}

-(CGFloat) rowHeightWithArray:(NSMutableArray *)array index:(NSInteger) index{
    NSNumber * num = [array objectAtIndex:index];
    return num.floatValue;
}

-(NSUInteger) minHeightInRowWithArray:(NSMutableArray *)array{
    
    NSUInteger minIndex = 0;
    for (int i = 1 ; i < array.count; i++) {
        NSNumber * num = [array objectAtIndex:i];
        NSNumber * minNum = [array objectAtIndex:minIndex];
        if (minNum.floatValue > num.floatValue) {
            minIndex = i;
        }
    }
    return minIndex;
}

-(NSUInteger) maxHeightInRowWithArray:(NSMutableArray *)array{
    
    NSUInteger maxIndex = 0;
    for (int i = 1 ; i < array.count; i++) {
        NSNumber * num = [array objectAtIndex:i];
        NSNumber * minNum = [array objectAtIndex:maxIndex];
        if (minNum.floatValue < num.floatValue) {
            maxIndex = i;
        }
    }
    return maxIndex;
}

-(CGFloat) maxHeightInArray:(NSMutableArray *)array{
    NSInteger index = [self maxHeightInRowWithArray:array];
    NSNumber * num =  [array objectAtIndex:index];
    return num.floatValue;
}


-(NSMutableArray * )  getAttributesInRectWithArray:(NSMutableArray *)array from:(NSInteger)from to:(NSInteger)to{
    UICollectionViewLayoutAttributes * fromAtt = [array objectAtIndex:from];
    
    UICollectionViewLayoutAttributes * toAtt = [array objectAtIndex:to];
    
    
    if ([self isContainRectWithLeftAttribute:fromAtt rightAttribute:toAtt] == false) {
        return nil;
    }
    if (fromAtt == toAtt) {
        return [NSMutableArray arrayWithObjects:fromAtt, nil];
    }
    NSInteger divide = (from + to) / 2;
    NSMutableArray * leftArray = [self getAttributesInRectWithArray:array from:from to:divide];
    NSMutableArray * rightArray = [self getAttributesInRectWithArray:array from:divide + 1 to:to];
    NSMutableArray * result = leftArray;
    if (result) {
        if (rightArray) {
            [result addObjectsFromArray:rightArray];
        }
    }else {
        result = rightArray;
    }
    return result;
}


-(BOOL) isContainRectWithLeftAttribute:(UICollectionViewLayoutAttributes *)left rightAttribute:(UICollectionViewLayoutAttributes *)right{
    
    if (self.verticalDir) {
        CGFloat top = left.frame.origin.y + self.collectionView.contentInset.top;
        CGFloat bottom = right.frame.origin.y + self.collectionView.contentInset.top + right.frame.size.height;
        if ((self.rect.origin.y > bottom)||
            (self.rect.origin.y + self.rect.size.height < top)) {
            return false;
        }else {
            return true;
        }
    }else {
        CGFloat top = left.frame.origin.x + self.collectionView.contentInset.left;
        CGFloat bottom = right.frame.origin.x + self.collectionView.contentInset.left + right.frame.size.width;
        if ((self.rect.origin.x > bottom)||
            (self.rect.origin.x + self.rect.size.width < top)) {
            return false;
        }else {
            return true;
        }
    }
}


-(NSMutableArray *)attributesArrayInRect{
    if (self.attributesArray.count > 0) {
        _attributesArrayInRect = [self getAttributesInRectWithArray:self.attributesArray from:0 to:self.attributesArray.count - 1];
    }else {
        _attributesArrayInRect = [NSMutableArray new];
    }
    return _attributesArrayInRect;
    
}

-(BOOL)verticalDir{
    return self.scrollDirection == UICollectionViewScrollDirectionVertical;
}


@end
