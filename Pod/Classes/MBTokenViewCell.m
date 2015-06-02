//
//  MBTokenViewCell.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenViewCell.h"
#import "MBTokenCollectionTokenView.h"
#import "MBCollectionView.h"

#define MIN_CELL_WIDTH 20
#define MIN_CELL_HEIGHT 20

@interface MBTokenViewCell ()
@property (nonatomic) BOOL initialiting;
@end

@implementation MBTokenViewCell

- (void)setTokenView:(MBTokenCollectionTokenView *)itemView
{
    if (_tokenView != itemView) {

        _initialiting = YES;
        [_tokenView removeFromSuperview];
        
        itemView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:itemView];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[itemView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(itemView)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[itemView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(itemView)]];
        
        _tokenView = itemView;
        _initialiting = NO;
    }
}

- (MBCollectionView *)collectionView
{
    UIView *view = self.superview;
    
    while (view != nil && ![view isKindOfClass:[MBCollectionView class]]) {
        view = view.superview;
    }
    
    return (MBCollectionView *)view;
}

- (void)itemViewDidInvalidateIntrinsicContentSize
{
    if (!_initialiting) {
        [[self collectionView] setNeedsInvalidateLayout];
    }
}

#pragma mark - Overridden Methods

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [_tokenView removeFromSuperview];
    _tokenView = nil;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self.tokenView setSelected:selected];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = self.tokenView.intrinsicContentSize;
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize fitSize = [self.tokenView sizeThatFits:size];

    if (fitSize.width < MIN_CELL_WIDTH)
        fitSize.width = MIN_CELL_WIDTH;

    if (fitSize.height < MIN_CELL_HEIGHT)
        fitSize.height = MIN_CELL_HEIGHT;

    return fitSize;
}

@end
