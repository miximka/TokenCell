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

@interface MBTokenCollectionTableViewCell () <MBTokenCollectionViewDataSource, MBTokenCollectionViewDelegate>
@end

@implementation MBTokenCollectionTableViewCell
{
    MBTokenCollectionView *_collectionView;
}

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

    collectionView.dataSource = self;
    collectionView.delegate = self;

    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [collectionView.addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:collectionView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    
    _collectionView = collectionView;
}

- (UILabel *)titleLabel
{
    return _collectionView.titleLabel;
}

- (IBAction)addContact:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCellDidTapAddButton:)]) {
        [self.delegate tokenCollectionTableViewCellDidTapAddButton:self];
    }
}

#pragma mark - Handling Tokens

- (void)addTokens:(NSArray *)tokens
{
    [_collectionView addTokens:tokens];
}

- (void)removeTokensAtIndexes:(NSIndexSet *)indexes
{
    [_collectionView removeTokensAtIndexes:indexes];
}

- (NSIndexSet *)selectedTokenIndexes
{
    return [_collectionView selectedTokenIndexes];
}

- (void)selectTokenAtIndex:(NSInteger)index animated:(BOOL)animated
{
    [_collectionView selectTokenAtIndex:index animated:animated];
}

#pragma mark - Cell Content Size

- (CGSize)contentSize
{
    return _collectionView.contentSize;
}

#pragma mark - Editing Text

- (void)setEditingText:(NSString *)text
{
    [_collectionView setText:text];
}

- (NSString *)editingText
{
    return [_collectionView text];
}

- (void)startEditing
{
    [_collectionView startEditing];
}

#pragma mark - Overridden Methods

- (void)prepareForReuse
{
    [super prepareForReuse];
    [_collectionView removeAllTokens];
}

#pragma mark - MBTokenCollectionViewDataSource

- (MBTokenCollectionTokenView *)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView viewForToken:(id<MBToken>)token
{
    return [self.dataSource tokenCollectionTableViewCell:self viewForToken:token];
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

- (BOOL)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView textFieldShouldReturnWithText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCell:textFieldShouldReturnWithText:)]) {
        return [self.delegate tokenCollectionTableViewCell:self textFieldShouldReturnWithText:text];
    }
    
    return YES;
}

- (void)tokenCollectionViewDeleteBackwardsInEmptyField:(MBTokenCollectionView *)tokenCollectionView
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCellDeleteBackwardsInEmptyField:)]) {
        [self.delegate tokenCollectionTableViewCellDeleteBackwardsInEmptyField:self];
    }
}

- (void)tokenCollectionViewDidChangeContentSize:(MBTokenCollectionView *)tokenCollectionView
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCellDidChangeContentSize:)]) {
        return [self.delegate tokenCollectionTableViewCellDidChangeContentSize:self];
    }
}

@end
