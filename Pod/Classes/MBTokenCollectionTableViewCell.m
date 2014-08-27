//
//  MBTokenCollectionTableViewCell.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenCollectionTableViewCell.h"
#import "MBTokenCollectionView.h"
#import "MBTokenItem.h"
#import "MBToken.h"

@interface MBTokenCollectionTableViewCell () <MBTokenCollectionViewDelegate>
@property (nonatomic) NSMutableArray *tokens;
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

- (void)configure
{
    _tokens = [NSMutableArray new];
    
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
    [_tokens addObjectsFromArray:tokens];
    
    for (id<MBToken> each in tokens) {
        
        MBTokenItem *tokenItem = [[MBTokenItem alloc] init];
        tokenItem.title = each.title;
        
        [self.collectionView addTokenItem:tokenItem animated:animated];
    }
}

- (void)removeTokensAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated
{
    [_tokens removeObjectsAtIndexes:indexes];
    [self.collectionView removeTokenItemsAtIndexes:indexes animated:animated];
}

- (NSIndexSet *)selectedTokenIndexes
{
    return [self.collectionView selectedItemIndexes];
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

#pragma mark - Overridden Methods

- (void)prepareForReuse
{
    [super prepareForReuse];

    [self.collectionView removeAllTokenItems];
    [_tokens removeAllObjects];
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

- (void)tokenCollectionViewTextFieldShouldReturn:(MBTokenCollectionView *)tokenCollectionView
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCellTextFieldShouldReturn:)]) {
        [self.delegate tokenCollectionTableViewCellTextFieldShouldReturn:self];
    }
}

- (void)tokenCollectionViewDeleteBackwardsInEmptyField:(MBTokenCollectionView *)tokenCollectionView
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCellDeleteBackwardsInEmptyField:)]) {
        [self.delegate tokenCollectionTableViewCellDeleteBackwardsInEmptyField:self];
    }
}

- (MBTokenCollectionItemView *)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView viewForTokenItem:(MBTokenItem *)tokenItem
{
    NSUInteger index = [self.collectionView.tokenItems indexOfObject:tokenItem];

    NSAssert(index != NSNotFound, @"TokenItem not found");
    NSAssert(index < self.tokens.count, @"Index out of bounds: %lu (count: %lu)", (unsigned long)index, (unsigned long)self.tokens.count);
    
    id<MBToken> token = self.tokens[index];
    
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
