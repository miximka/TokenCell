//
//  MBTokenCollectionView.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenCollectionView.h"
#import "MBTokenCollectionViewTokenLayout.h"
#import "MBTextFieldToken.h"
#import "MBTokenViewCell.h"
#import "MBTokenTextFieldCell.h"
#import "MBCollectionView.h"
#import "MBTokenCollectionTokenView.h"

#define TOKEN_VIEW_CELL_IDENTIFIER    @"TokenViewCell"
#define TEXT_FIELD_CELL_IDENTIFIER    @"TextFieldCell"

@interface MBTokenCollectionView () <UICollectionViewDataSource, MBCollectionViewDelegate, MBTokenCollectionViewDelegateTokenLayout>
@property (weak, nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic) MBTokenViewCell *tokenSizingCell;
@property (nonatomic) MBTokenTextFieldCell *textFieldTokenSizingCell;
@property (nonatomic) MBTextFieldToken *textFieldToken;
@property (nonatomic) UINib *tokenCollectionItemViewNib;
@end

@implementation MBTokenCollectionView
{
    NSMutableArray *_tokens;
    BOOL _collectionViewDidReloadDataOnce;
}

- (id)initWithFrame:(CGRect)frame
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

- (void)dealloc
{
    [_collectionView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)addCollectionView
{
    MBTokenCollectionViewTokenLayout *layout = [[MBTokenCollectionViewTokenLayout alloc] init];
    UICollectionView *collectionView = [[MBCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];

    //Configure collection view
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.allowsMultipleSelection = YES;
    collectionView.scrollEnabled = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    //Register collection view cells
    [collectionView registerClass:[MBTokenViewCell class] forCellWithReuseIdentifier:TOKEN_VIEW_CELL_IDENTIFIER];
    [collectionView registerClass:[MBTokenTextFieldCell class] forCellWithReuseIdentifier:TEXT_FIELD_CELL_IDENTIFIER];

    //Instantiate cells to be used for intrinsic cell content size calculations
    self.tokenSizingCell = [[MBTokenViewCell alloc] init];
    self.textFieldTokenSizingCell = [[MBTokenTextFieldCell alloc] init];

    //Add collection view to view hierarchy and attach constraints
    [self addSubview:collectionView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(collectionView)]];

    //Register for KVO notifications
    [collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:nil];
    
    _collectionView = collectionView;
}

- (void)addTitleLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:label];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

    _titleLabel = label;
}

- (void)addAddButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.translatesAutoresizingMaskIntoConstraints = NO;

    button.alpha = 0.0;
    [self addSubview:button];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[button]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    
    _addButton = button;
}

- (void)notifyDelegateTextDidChange:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionView:didChangeText:)]) {
        [self.delegate tokenCollectionView:self didChangeText:text];
    }
}

- (void)notifyDelegateDidEndEditingText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionView:didEndEditingText:)]) {
        [self.delegate tokenCollectionView:self didEndEditingText:text];
    }
}

- (void)notifyDelegateDidChangeContentSize
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionViewDidChangeContentSize:)]) {
        [self.delegate tokenCollectionViewDidChangeContentSize:self];
    }
}

- (void)textFieldDidBeginEditing
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.addButton setHidden:NO];
        [self.addButton setAlpha:1.0];
    }];
}

- (void)textFieldDidEndEditingWithText:(NSString *)text
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.addButton setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.addButton setHidden:YES];
    }];
    
    [self notifyDelegateDidEndEditingText:text];

    //Automatically deselect all items when edit field resigns first responder
    for (NSIndexPath *each in self.collectionView.indexPathsForSelectedItems) {
        [self.collectionView deselectItemAtIndexPath:each animated:YES];
    }
}

- (BOOL)textFieldShouldReturnWithText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionView:textFieldShouldReturnWithText:)]) {
        return [self.delegate tokenCollectionView:self textFieldShouldReturnWithText:text];
    }
    
    return YES;
}

- (void)configure
{
    MBTextFieldToken *textFieldToken = [[MBTextFieldToken alloc] init];
    
    __weak MBTokenCollectionView *weakSelf = self;

    textFieldToken.textBeginEditingHandler = ^{
        [weakSelf textFieldDidBeginEditing];
    };

    textFieldToken.textDidChangeHandler = ^(NSString *text){
        [weakSelf notifyDelegateTextDidChange:text];
    };

    textFieldToken.textEndEditingHandler = ^(NSString *text) {
        [weakSelf textFieldDidEndEditingWithText:text];
    };

    textFieldToken.textFieldShouldReturnHandler = ^BOOL(NSString *text) {
        return [weakSelf textFieldShouldReturnWithText:text];
    };

    textFieldToken.deleteBackwardsInEmptyFieldHandler = ^() {
        [weakSelf notifyDelegateDeleteBackwardsInEmptyField];
    };

    _textFieldToken = textFieldToken;
    
    NSMutableArray *items = [NSMutableArray arrayWithObject:textFieldToken];
    _tokens = items;
    
    [self addCollectionView];
    [self addTitleLabel];
    [self addAddButton];
}

- (void)notifyDelegateDeleteBackwardsInEmptyField
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionViewDeleteBackwardsInEmptyField:)]) {
        [self.delegate tokenCollectionViewDeleteBackwardsInEmptyField:self];
    }
}

#pragma mark - Manage Token Items

- (NSArray *)tokens
{
    NSMutableArray *tokens = [_tokens mutableCopy];
    [tokens removeObject:self.textFieldToken];
    
    return tokens;
}

- (void)addTokens:(NSArray *)tokens
{
    NSInteger index = [_tokens indexOfObject:self.textFieldToken];

    //Add token always before text field
    NSAssert(index != NSNotFound, @"Text field item not found");

    for (id<MBToken> each in tokens) {
        
        [_tokens insertObject:each atIndex:index];
        
        if (_collectionViewDidReloadDataOnce) {
            //Only directly update collection view items when it has reloaded its data at least once
            //otherwize we get exception when triggering -insertItemsAtIndexPaths:
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        }

        index++;
    }
}

- (void)removeTokensAtIndexes:(NSIndexSet *)indexes
{
    [_tokens removeObjectsAtIndexes:indexes];

    NSMutableArray *indexPaths = [NSMutableArray new];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        [indexPaths addObject:indexPath];
    }];
    
    if (_collectionViewDidReloadDataOnce) {
        //Only directly update collection view items when it has reloaded its data at least once
        //otherwize we get exception when triggering -deleteItemsAtIndexPaths:

        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    }
}

- (void)removeAllTokens
{
    [_tokens removeAllObjects];
    [_tokens addObject:self.textFieldToken];
    
    [self.collectionView reloadData];
}

- (NSIndexSet *)selectedTokenIndexes
{
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    
    NSMutableIndexSet *indexes = [NSMutableIndexSet new];
    for (NSIndexPath *each in indexPaths) {
        [indexes addIndex:each.row];
    }
    
    return indexes;
}

- (void)selectTokenAtIndex:(NSInteger)index animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark - Creating Token Collection Item Views

- (void)registerNibForTokenCollectionItemView:(UINib *)nib
{
    self.tokenCollectionItemViewNib = nib;
}

#pragma mark - Display Content

- (CGSize)contentSize
{
    return self.collectionView.contentSize;
}

#pragma mark - Editing Text

- (void)setText:(NSString *)text
{
    self.textFieldToken.text = text;
}

- (NSString *)text
{
    return self.textFieldToken.text;
}

- (void)startEditing
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[_tokens indexOfObject:self.textFieldToken] inSection:0];
    MBTokenTextFieldCell *cell = (MBTokenTextFieldCell *)[self.collectionView cellForItemAtIndexPath:indexPath];

    [cell.textField becomeFirstResponder];
}

#pragma mark - Configure Cells

- (void)configureTokenViewCell:(MBTokenViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<MBToken> token = _tokens[indexPath.item];
    
    MBTokenCollectionTokenView *tokenView = nil;
    
    if (self.tokenCollectionItemViewNib) {
        //Instantiate new view from nib
        tokenView = (MBTokenCollectionTokenView *)[self.tokenCollectionItemViewNib instantiateWithOwner:nil options:nil].firstObject;
        NSAssert([tokenView isKindOfClass:[MBTokenCollectionTokenView class]], @"Unexpected token view: %@", tokenView);
    } else {
        //Ask delegate for the view
        tokenView = [self.dataSource tokenCollectionView:self viewForToken:token];
    }
    
    NSAssert(tokenView != nil, @"tokenView != nil not satisfied");
    cell.tokenView = tokenView;
}

- (void)configureTokenTextFieldCell:(MBTokenTextFieldCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBTextFieldToken *token = _tokens[indexPath.item];
    cell.token = token;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Whenever user selects any item in the collection view we want to focus text field to start editing
    [self startEditing];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //Immediately reload collection view's data to workaround the problem with exception thrown by collection view when adding items directly after initialization
    _collectionViewDidReloadDataOnce = YES;
    
    return _tokens.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [_tokens objectAtIndex:indexPath.item];
    
    if ([item isKindOfClass:[MBTextFieldToken class]]) {
        
        MBTokenTextFieldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TEXT_FIELD_CELL_IDENTIFIER forIndexPath:indexPath];
        [self configureTokenTextFieldCell:cell forItemAtIndexPath:indexPath];
        return cell;
    }
    
    if ([item conformsToProtocol:@protocol(MBToken)]) {

        MBTokenViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TOKEN_VIEW_CELL_IDENTIFIER forIndexPath:indexPath];
        [self configureTokenViewCell:cell forItemAtIndexPath:indexPath];
        return cell;
        
    }

    return nil;
}

#pragma mark - MBTokenCollectionViewDelegateTokenLayout

- (CGRect)collectionViewTopLeftContentFreeRect:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return self.titleLabel.frame;
}

- (CGRect)collectionViewTopRightContentFreeRect:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return self.addButton.frame;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout intrinsicItemSizeAtIndexPath:(NSIndexPath *)indexPath
{
    id token = [_tokens objectAtIndex:indexPath.item];
    
    if ([token isKindOfClass:[MBTextFieldToken class]]) {
        [self configureTokenTextFieldCell:self.textFieldTokenSizingCell forItemAtIndexPath:indexPath];
        return self.textFieldTokenSizingCell.intrinsicContentSize;
    }
    
    [self configureTokenViewCell:self.tokenSizingCell forItemAtIndexPath:indexPath];
    return self.tokenSizingCell.intrinsicContentSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeThatFits:(CGSize)size forItemAtIndexPath:(NSIndexPath *)indexPath
{
    id token = [_tokens objectAtIndex:indexPath.item];

    if ([token isKindOfClass:[MBTextFieldToken class]]) {
        
        [self configureTokenTextFieldCell:self.textFieldTokenSizingCell forItemAtIndexPath:indexPath];
        return [self.textFieldTokenSizingCell sizeThatFits:size];
    }
    
    [self configureTokenViewCell:self.tokenSizingCell forItemAtIndexPath:indexPath];
    return [self.tokenSizingCell sizeThatFits:size];
}

#pragma mark - MBCollectionViewDelegate

- (void)collectionViewDidTouchInside:(MBCollectionView *)collectionView
{
    [self startEditing];
}

#pragma mark - KVO Notifications

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {

        CGSize oldSize = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
        CGSize newSize = self.collectionView.contentSize;
        
        if (!CGSizeEqualToSize(oldSize, newSize)) {
            //Notify delegate asynchronously to workaround problems of unnoticed subsequent changes happend in react to the delegate notification
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self notifyDelegateDidChangeContentSize];
            });
        }
    }
}

@end
