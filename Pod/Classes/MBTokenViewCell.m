//
//  MBTokenViewCell.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenViewCell.h"
#import "MBTokenCollectionItemView.h"

#define MIN_CELL_WIDTH 20
#define MIN_CELL_HEIGHT 20

@interface MBTokenViewCell ()
@property (nonatomic) BOOL initialiting;
@end

@implementation MBTokenViewCell

- (void)setItemView:(MBTokenCollectionItemView *)itemView
{
    if (_itemView != itemView) {
        
        _initialiting = YES;
        
        itemView.translatesAutoresizingMaskIntoConstraints = NO;

        [self.contentView addSubview:itemView];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(itemView)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[itemView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(itemView)]];
        
        _itemView = itemView;
        
        _initialiting = NO;
    }
}

- (UICollectionView *)collectionView
{
    UIView *view = self.superview;
    
    while (view != nil && ![view isKindOfClass:[UICollectionView class]]) {
        view = view.superview;
    }
    
    return (UICollectionView *)view;
}

- (void)itemViewDidInvalidateIntrinsicContentSize
{
    if (!_initialiting) {
        [[[self collectionView] collectionViewLayout] invalidateLayout];
    }
}

#pragma mark - Overridden Methods

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [_itemView removeFromSuperview];
    _itemView = nil;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self.itemView setSelected:selected];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = self.itemView.intrinsicContentSize;
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize fitSize = [self.itemView sizeThatFits:size];

    if (fitSize.width < MIN_CELL_WIDTH)
        fitSize.width = MIN_CELL_WIDTH;

    if (fitSize.height < MIN_CELL_HEIGHT)
        fitSize.height = MIN_CELL_HEIGHT;

    return fitSize;
}

@end
