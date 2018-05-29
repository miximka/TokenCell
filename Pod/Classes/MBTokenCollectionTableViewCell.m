//
//  MBTokenCollectionTableViewCell.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenCollectionTableViewCell.h"
#import "MBTokenCollectionView.h"

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
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [self.contentView addSubview:collectionView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];

    //Make collection view slightly bigger than the cell it is wrapped into.
    //This workaround fixes the problem with wrongly positioned UITextField when table view cell is resized (gets bigger with animation) and the text field token (always the last one) is
    //forced to go to the next line, but fails to do so and remains on the same place...
    //I think the problem happends because at the time when "update layout" is called on the collection view, the collection view rect has not yet been resized
    //and collection view thinks that the text view token will be invisible anyway and doesn't push it into correct position.
    //I did not find satisfactory solution for this problem yet, so this is the warkaround: increase the size of the underlying collection view so it thinks the next line is
    //visible and correctly puts the text field token when cell is resized.
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]-(-20)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    
    //Clip bot bounds to not draw above other ui elements when cell is being resized
    self.clipsToBounds = YES;
    
    _collectionView = collectionView;
}

- (UILabel *)titleLabel
{
    return _collectionView.titleLabel;
}

- (UIView *)rightView
{
    return _collectionView.rightView;
}

- (void)setRightView:(UIView *)view
{
    _collectionView.rightView = view;
}

#pragma mark - Reloading Content

- (void)reloadData
{
    [_collectionView reloadData];
}

#pragma mark - Inserting and Deleting Tokens

- (void)insertTokensAtIndexes:(NSIndexSet *)indexes
{
    [_collectionView insertTokensAtIndexes:indexes];
}

- (void)deleteTokensAtIndexes:(NSIndexSet *)indexes
{
    [_collectionView deleteTokensAtIndexes:indexes];
}

#pragma mark - Managing the Selection

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

- (void)setTextFieldText:(NSString *)text
{
    [_collectionView setText:text];
}

- (NSString *)textFieldText
{
    return [_collectionView text];
}

- (void)startEditing
{
    [_collectionView startEditing];
}

#pragma mark - MBTokenCollectionViewDataSource

- (NSUInteger)numberOfTokensInCollectionView:(MBTokenCollectionView *)tokenCollectionView
{
    return [self.dataSource numberOfTokensInTokenCollectionTableViewCell:self];
}

- (MBTokenCollectionTokenView *)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView viewForTokenAtIndex:(NSUInteger)index
{
    return [self.dataSource tokenCollectionTableViewCell:self viewForTokenAtIndex:index];
}

#pragma mark - MBTokenCollectionViewDelegate

- (void)tokenCollectionViewDidStartEditing:(MBTokenCollectionView *)tokenCollectionView
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionTableViewCellDidStartEditing:)]) {
        [self.delegate tokenCollectionTableViewCellDidStartEditing:self];
    }
}

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
