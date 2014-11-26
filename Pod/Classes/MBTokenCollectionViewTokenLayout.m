//
//  MBTokenCollectionViewTokenLayout.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 21/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenCollectionViewTokenLayout.h"

#define INSET 10.0
#define TOP_INSET 10.0
#define ITEM_HEIGHT 24.0
#define INTERITEM_SPACING 5.0

#define ITEM_CELL_KIND @"ItemCell"

@interface MBTokenCollectionViewTokenLayout ()
@property (nonatomic) NSDictionary *layoutInfo;
@property (nonatomic) NSUInteger maxNumRows;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic) NSUInteger numOfLines;
@property (nonatomic) CGRect topLeftFreeContentRect;
@property (nonatomic) CGRect topRightFreeContentRect;
@end

@implementation MBTokenCollectionViewTokenLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _insets = UIEdgeInsetsMake(TOP_INSET, INSET, INSET, INSET);
    }
    return self;
}

- (CGRect)lineRectForIndex:(NSUInteger)lineIndex
{
    CGRect bounds = self.collectionView.bounds;
    
    CGFloat verticalOffset = _insets.top + lineIndex * (ITEM_HEIGHT + _insets.top);
    CGRect lineRect = CGRectMake(_insets.left, verticalOffset, bounds.size.width - (_insets.left + _insets.right), ITEM_HEIGHT);
    
    if (CGRectIntersectsRect(lineRect, self.topLeftFreeContentRect)) {
        CGFloat deltaX = CGRectGetMaxX(self.topLeftFreeContentRect) - CGRectGetMinX(lineRect) + _insets.left;
        lineRect.origin.x += deltaX;
        lineRect.size.width -= deltaX;
    }

    if (CGRectIntersectsRect(lineRect, self.topRightFreeContentRect)) {
        CGFloat deltaX = CGRectGetMaxX(lineRect) - CGRectGetMinX(self.topRightFreeContentRect) + _insets.right;
        lineRect.size.width -= deltaX;
    }

    return lineRect;
}

- (id<MBTokenCollectionViewDelegateTokenLayout>)delegate
{
     return (id<MBTokenCollectionViewDelegateTokenLayout>) self.collectionView.delegate;
}

#pragma mark Overridden Methods

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSMutableDictionary *layoutInfo = [NSMutableDictionary new];
    NSMutableDictionary *cellInfo = [NSMutableDictionary new];
    
    NSAssert(self.collectionView.numberOfSections == 1, @"Expected only one section");
    NSInteger numItems = [self.collectionView numberOfItemsInSection:0];

    self.topLeftFreeContentRect = [self.delegate collectionViewTopLeftContentFreeRect:self.collectionView layout:self];
    self.topRightFreeContentRect = [self.delegate collectionViewTopRightContentFreeRect:self.collectionView layout:self];
    
    //Calculate first line rect
    NSUInteger lineIndex = 0;
    CGRect lineRect = [self lineRectForIndex:lineIndex];
    CGRect freeSpaceRect = lineRect;

    NSInteger item = 0;

    while (item < numItems) {

        //Index path of the item
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        
        //Get intrinsic item size
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self intrinsicItemSizeAtIndexPath:indexPath];
        
        BOOL useNextLine = NO;
        
        if (itemSize.width == UIViewNoIntrinsicMetric || freeSpaceRect.size.width < itemSize.width) {
            //Item does not provide intrinsic size OR there are not enought space for the item in line

            //Find out if we can squeeze item into the line by resizing it down
            itemSize = [self.delegate collectionView:self.collectionView layout:self sizeThatFits:freeSpaceRect.size forItemAtIndexPath:indexPath];
            
            if (freeSpaceRect.size.width < itemSize.width) {
                //We even can't squeeze the item down to fit it into the remaining space of the line

                if (CGRectEqualToRect(lineRect, freeSpaceRect)) {
                    //This is completely free line - we can't allow item be wider than a line so we shrink it down to the max width
                    itemSize = freeSpaceRect.size;
                } else {
                    //Try to fit item into next line
                    useNextLine = YES;
                }
            }
        }
        
        if (useNextLine) {

            //Calculate rect of next line
            lineIndex++;
            lineRect = [self lineRectForIndex:lineIndex];
            freeSpaceRect = lineRect;

            continue;
        }
        
        //Item frame
        CGRect itemFrame = freeSpaceRect;
        itemFrame.size.width = itemSize.width;
        
        BOOL isLastItem = item == numItems - 1;
        if (isLastItem) {
            
            BOOL occupyFreeSpaceInLine = [self.delegate collectionViewShouldOccupyRemainingFreeSpace:self.collectionView layout:self forItemAtIndexPath:indexPath];
            if (occupyFreeSpaceInLine) {
                //Last item may occupy entire free space in line
                itemFrame = freeSpaceRect;
            }
        }

        //Create item attributes
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = itemFrame;
        cellInfo[indexPath] = attributes;

        //Decrease free space in the line accordingly
        CGFloat occupiedWidht = itemSize.width + INTERITEM_SPACING;
        freeSpaceRect.origin.x += occupiedWidht;
        freeSpaceRect.size.width -= occupiedWidht;
        
        //Go to the next item
        item++;
    }

    layoutInfo[ITEM_CELL_KIND] = cellInfo;

    NSUInteger numOfLines = 0;
    if (numItems > 0) {
        numOfLines = lineIndex + 1;
    }
    
    self.numOfLines = numOfLines;
    self.layoutInfo = layoutInfo;
}

- (CGSize)collectionViewContentSize
{
    if (self.numOfLines == 0)
        return CGSizeZero;
    
    CGFloat contentHeight = _insets.top + self.numOfLines * (ITEM_HEIGHT + INSET);
    CGSize contentSize = CGSizeMake(self.collectionView.bounds.size.width, contentHeight);
    
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = self.layoutInfo[ITEM_CELL_KIND][indexPath];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSDictionary *layoutInfo = self.layoutInfo;
    __block NSMutableArray *attributes = [NSMutableArray new];

    for (NSString *key in layoutInfo) {
        NSDictionary *cellInfo = layoutInfo[key];
        
        [cellInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *key, UICollectionViewLayoutAttributes *itemAttributes, BOOL *stop) {
            
            CGRect itemFrame = itemAttributes.frame;
            if (CGRectIntersectsRect(rect, itemFrame)) {
                [attributes addObject:itemAttributes];
            }
        }];
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(oldBounds) != CGRectGetWidth(newBounds)) {
        return YES;
    }
    
    return NO;
}

@end

