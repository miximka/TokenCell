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
@property (weak, nonatomic) MBCollectionView *collectionView;
@property (nonatomic) MBTokenViewCell *tokenSizingCell;
@property (nonatomic) MBTokenTextFieldCell *textFieldTokenSizingCell;
@property (nonatomic) MBTextFieldToken *textFieldToken;
@property (nonatomic) UINib *tokenCollectionItemViewNib;
@end

@implementation MBTokenCollectionView
{
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
    MBCollectionView *collectionView = [[MBCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];

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

- (void)addRightView:(UIView *)view
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.alpha = 0.0;
    
    [self addSubview:view];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[view]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
}

- (void)setRightView:(UIView *)view
{
    if (_rightView != view) {
        
        [_rightView removeFromSuperview];
        _rightView = view;
        
        if (view) {
            [self addRightView:view];
        }
        
        [self.collectionView setNeedsInvalidateLayout];
    }
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
        [self.rightView setHidden:NO];
        [self.rightView setAlpha:1.0];
    }];
}

- (void)textFieldDidEndEditingWithText:(NSString *)text
{
    [self notifyDelegateDidEndEditingText:text];

    //Automatically deselect all items when edit field resigns first responder
    for (NSIndexPath *each in self.collectionView.indexPathsForSelectedItems) {
        [self.collectionView deselectItemAtIndexPath:each animated:YES];
    }

    //Hide right supplementary view
    [UIView animateWithDuration:0.3 animations:^{
        [self.rightView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.rightView setHidden:YES];
    }];

    NSUInteger textFieldIndex = [self numberOfTokens] - 1;

    //Remove text field token when it resigns first responder
    self.textFieldToken = nil;
    [self deleteTokensAtIndexes:[NSIndexSet indexSetWithIndex:textFieldIndex]];
}

- (BOOL)textFieldShouldReturnWithText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionView:textFieldShouldReturnWithText:)]) {
        return [self.delegate tokenCollectionView:self textFieldShouldReturnWithText:text];
    }
    
    return YES;
}

- (MBTextFieldToken *)preparedTextFieldToken
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
    
    return textFieldToken;
}

- (void)configure
{
    [self addCollectionView];
    [self addTitleLabel];
}

- (void)notifyDelegateDeleteBackwardsInEmptyField
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionViewDeleteBackwardsInEmptyField:)]) {
        [self.delegate tokenCollectionViewDeleteBackwardsInEmptyField:self];
    }
}

- (NSUInteger)numberOfTokens
{
    NSUInteger count = [self.dataSource numberOfTokensInCollectionView:self];

    if (self.textFieldToken != nil) {
        //Account for the embedded text field token
        count++;
    }
    
    return count;
}

#pragma mark - Reloading Content

- (void)reloadData
{
    [_collectionView reloadData];
}

#pragma mark - Inserting and Deleting Tokens

- (NSArray *)indexPathsFromIndexes:(NSIndexSet *)indexes
{
    __block NSMutableArray *indexPaths = [NSMutableArray new];
    
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }];
    
    return indexPaths;
}

- (void)insertTokensAtIndexes:(NSIndexSet *)indexes
{
    NSArray *indexPaths = [self indexPathsFromIndexes:indexes];
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

- (void)deleteTokensAtIndexes:(NSIndexSet *)indexes
{
    NSArray *indexPaths = [self indexPathsFromIndexes:indexes];
    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
}

#pragma mark - Managing the Selection

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

- (NSInteger)textFieldTokenIndex
{
    if (self.textFieldToken) {
        return [self numberOfTokens] - 1;
    }
    
    return NSNotFound;
}

- (BOOL)isTextFieldTokenAtIndex:(NSInteger)index
{
    if (index == NSNotFound) {
        return NO;
    }
    
    return index == [self textFieldTokenIndex];
}

- (MBTokenTextFieldCell *)textFieldCell
{
    if (!self.textFieldToken) {
        return nil;
    }
    
    NSUInteger index = [self numberOfTokens] - 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    MBTokenTextFieldCell *cell = (MBTokenTextFieldCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    return cell;
}

- (void)startEditing
{
    if (self.textFieldToken != nil) {
        //Already editing
        return;
    }

    //Create text field token and add it to the collection view
    self.textFieldToken = [self preparedTextFieldToken];
    [self insertTokensAtIndexes:[NSIndexSet indexSetWithIndex:[self textFieldTokenIndex]]];

    //Immediately start editing
    [[self textFieldCell] startEditing];
    
    //Workaround for the problem where the text field won't become first responder until the ce
    //Make text field first responder during next runloop cycle to workaround the issue where the text field won't become first responder if
    //it was added with frame which is not visible on screen yet (e.g. when cell's height is not enough yet to present text field)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self textFieldCell] startEditing];
    });
}

#pragma mark - Configure Cells

- (void)configureTokenViewCell:(MBTokenViewCell *)cell forTokenAtIndex:(NSUInteger)index
{
    MBTokenCollectionTokenView *tokenView = nil;
    
    if (self.tokenCollectionItemViewNib) {
        //Instantiate new view from nib
        tokenView = (MBTokenCollectionTokenView *)[self.tokenCollectionItemViewNib instantiateWithOwner:nil options:nil].firstObject;
        NSAssert([tokenView isKindOfClass:[MBTokenCollectionTokenView class]], @"Unexpected token view: %@", tokenView);
    } else {
        //Ask delegate for the view
        tokenView = [self.dataSource tokenCollectionView:self viewForTokenAtIndex:index];
    }
    
    NSAssert(tokenView != nil, @"tokenView != nil not satisfied");
    cell.tokenView = tokenView;
}

- (void)configureTokenTextFieldCell:(MBTokenTextFieldCell *)cell
{
    cell.token = self.textFieldToken;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //Immediately reload collection view's data to workaround the problem with exception thrown by collection view when adding items directly after initialization
    _collectionViewDidReloadDataOnce = YES;
    return [self numberOfTokens];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.item;

    if ([self isTextFieldTokenAtIndex:index]) {
        //Should return cell for embedded text field token
        MBTokenTextFieldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TEXT_FIELD_CELL_IDENTIFIER forIndexPath:indexPath];
        [self configureTokenTextFieldCell:cell];
        return cell;

    } else {
        //Should return cell for custom token
        MBTokenViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TOKEN_VIEW_CELL_IDENTIFIER forIndexPath:indexPath];
        [self configureTokenViewCell:cell forTokenAtIndex:index];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Whenever user selects any item in the collection view we want to focus text field to start editing
    [self startEditing];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.delegate respondsToSelector:@selector(tokenCollectionView:willDisplayTokenView:forTokenAtIndex:)]) {
        return;
    }
    
    NSUInteger index = indexPath.item;
    if ([self isTextFieldTokenAtIndex:index]) {
        return;
    }

    MBTokenViewCell *tokenViewCell = (MBTokenViewCell *)cell;
    NSAssert([tokenViewCell isKindOfClass:[MBTokenViewCell class]], @"Unexpected cell class");
    [self.delegate tokenCollectionView:self willDisplayTokenView:tokenViewCell.tokenView forTokenAtIndex:indexPath.item];
}

#pragma mark - MBTokenCollectionViewDelegateTokenLayout

- (CGRect)collectionViewTopLeftContentFreeRect:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return self.titleLabel.frame;
}

- (CGRect)collectionViewTopRightContentFreeRect:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return self.rightView.frame;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout intrinsicItemSizeAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    NSUInteger index = indexPath.item;
    
    if ([self isTextFieldTokenAtIndex:index]) {

        MBTokenTextFieldCell *cell = self.textFieldTokenSizingCell;
        [self configureTokenTextFieldCell:cell];
        size = cell.intrinsicContentSize;
        
    } else {

        [self configureTokenViewCell:self.tokenSizingCell forTokenAtIndex:indexPath.item];
        size = self.tokenSizingCell.intrinsicContentSize;
    }
    
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeThatFits:(CGSize)size forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.item;

    if ([self isTextFieldTokenAtIndex:index]) {
        
        MBTokenTextFieldCell *cell = self.textFieldTokenSizingCell;
        [self configureTokenTextFieldCell:cell];
        return [cell sizeThatFits:size];
    }
    
    [self configureTokenViewCell:self.tokenSizingCell forTokenAtIndex:indexPath.item];
    return [self.tokenSizingCell sizeThatFits:size];
}

- (BOOL)collectionViewShouldOccupyRemainingFreeSpace:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.item;
    return [self isTextFieldTokenAtIndex:index];
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
