//
//  MBTokenCollectionTableViewCell.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenCollectionTableViewCell.h"
#import "MBTokenCollectionView.h"
#import "MBToken.h"

@interface MBTokenCollectionTableViewCell () <MBTokenCollectionViewDelegate>
@end

@implementation MBTokenCollectionTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    MBTokenCollectionView *collectionView = [[MBTokenCollectionView alloc] init];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [collectionView.addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    collectionView.delegate = self;
    
    [self.contentView addSubview:collectionView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    
    _collectionView = collectionView;
}

- (UILabel *)titleLabel
{
    return self.collectionView.titleLabel;
}

- (IBAction)addContact:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCellDidTapAddButton:)]) {
        [self.delegate tokenCollectionTableViewCellDidTapAddButton:self];
    }
}

#pragma mark - Handling Tokens

- (void)addTokens:(NSArray *)tokens animated:(BOOL)animated
{
    [self.collectionView addTokens:tokens animated:animated];
}

- (void)removeTokensAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated
{
    [self.collectionView removeTokensAtIndexes:indexes animated:animated];
}

- (NSIndexSet *)selectedTokenIndexes
{
    return [self.collectionView selectedTokenIndexes];
}

- (void)selectTokenAtIndex:(NSInteger)index animated:(BOOL)animated
{
    [self.collectionView selectTokenAtIndex:index animated:animated];
}

#pragma mark - Cell Content Size

- (CGSize)contentSize
{
    return self.collectionView.contentSize;
}

#pragma mark - Editing Text

- (void)setEditingText:(NSString *)text
{
    [self.collectionView setText:text];
}

- (NSString *)editingText
{
    return [self.collectionView text];
}

- (void)startEditing
{
    [self.collectionView startEditing];
}

#pragma mark - Overridden Methods

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.collectionView removeAllTokens];
}

#pragma mark - MBTokenCollectionViewDelegate

- (void)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView didChangeText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCell:didChangeText:)]) {
        [self.delegate tokenCollectionTableViewCell:self didChangeText:text];
    }
}

- (void)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView didEndEditingText:(NSString *)text
{
    [self.delegate tokenCollectionTableViewCell:self didEndEditingWithText:text];
}

- (void)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView textFieldShouldReturnWithText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCell:textFieldShouldReturnWithText:)]) {
        [self.delegate tokenCollectionTableViewCell:self textFieldShouldReturnWithText:text];
    }
}

- (void)tokenCollectionViewDeleteBackwardsInEmptyField:(MBTokenCollectionView *)tokenCollectionView
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCellDeleteBackwardsInEmptyField:)]) {
        [self.delegate tokenCollectionTableViewCellDeleteBackwardsInEmptyField:self];
    }
}

- (MBTokenCollectionTokenView *)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView viewForToken:(id<MBToken>)token
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCell:viewForToken:)]) {
        return [self.delegate tokenCollectionTableViewCell:self viewForToken:token];
    }
    
    return nil;
}

- (void)tokenCollectionViewDidChangeContentSize:(MBTokenCollectionView *)tokenCollectionView
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCellDidChangeContentSize:)]) {
        return [self.delegate tokenCollectionTableViewCellDidChangeContentSize:self];
    }
}

@end
