//
//  MBTokenCollectionView.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenCollectionView.h"
#import "MBTokenCollectionViewTokenLayout.h"
#import "MBTokenItem.h"
#import "MBTextFieldItem.h"
#import "MBTokenViewCell.h"
#import "MBTokenTextFieldCell.h"
#import "MBTokenCollectionItemLabel.h"

#define TOKEN_VIEW_CELL_IDENTIFIER    @"TokenViewCell"
#define TEXT_FIELD_CELL_IDENTIFIER    @"TextFieldCell"

@interface MBTokenCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, MBTokenCollectionViewDelegateTokenLayout>
@property (weak, nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic) MBTokenViewCell *tokenItemSizingCell;
@property (nonatomic) MBTokenTextFieldCell *tokenTextFieldItemSizingCell;
@property (nonatomic) MBTextFieldItem *textFieldItem;
@property (nonatomic) UINib *tokenCollectionItemViewNib;
@end

@implementation MBTokenCollectionView
{
    NSMutableArray *_items;
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
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];

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
    self.tokenItemSizingCell = [[MBTokenViewCell alloc] init];
    self.tokenTextFieldItemSizingCell = [[MBTokenTextFieldCell alloc] init];

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
        [self.addButton setAlpha:1.0];
    }];
}

- (void)textFieldDidEndEditingWithText:(NSString *)text
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.addButton setAlpha:0.0];
    }];
    
    [self notifyDelegateDidEndEditingText:text];
}

- (void)textFieldShouldReturn
{
    if ([self.delegate respondsToSelector:@selector(tokenCollectionViewTextFieldShouldReturn:)]) {
        [self.delegate tokenCollectionViewTextFieldShouldReturn:self];
    }
}

- (void)configure
{
    MBTextFieldItem *textFieldItem = [[MBTextFieldItem alloc] init];
    
    __weak MBTokenCollectionView *weakSelf = self;

    textFieldItem.textBeginEditingHandler = ^{
        [weakSelf textFieldDidBeginEditing];
    };

    textFieldItem.textDidChangeHandler = ^(NSString *text){
        [weakSelf notifyDelegateTextDidChange:text];
    };

    textFieldItem.textEndEditingHandler = ^(NSString *text) {
        [weakSelf textFieldDidEndEditingWithText:text];
    };

    textFieldItem.textFieldShouldReturnHandler = ^() {
        [weakSelf textFieldShouldReturn];
    };

    textFieldItem.deleteBackwardsInEmptyFieldHandler = ^() {
        [weakSelf notifyDelegateDeleteBackwardsInEmptyField];
    };

    _textFieldItem = textFieldItem;
    
    NSMutableArray *items = [NSMutableArray arrayWithObject:textFieldItem];
    _items = items;
    
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

- (NSArray *)tokenItems
{
    NSMutableArray *tokens = [_items mutableCopy];
    [tokens removeObject:self.textFieldItem];
    
    return tokens;
}

- (void)addTokenItem:(MBTokenItem *)item animated:(BOOL)animated
{
    [self addTokenItems:@[item] animated:animated];
}

- (void)addTokenItems:(NSArray *)items animated:(BOOL)animated
{
    NSInteger index = [_items indexOfObject:self.textFieldItem];

    //Add token always before text field
    NSAssert(index != NSNotFound, @"Text field item not found");

    for (MBTokenItem *each in items) {
        
        [_items insertObject:each atIndex:index];
        
        if (animated) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        }
        
        index++;
    }
}

- (void)removeTokenItem:(MBTokenItem *)item animated:(BOOL)animated
{
    if (!item)
        return;
    
    NSUInteger index = [_items indexOfObject:item];
    NSAssert(index != NSNotFound, @"Item not found");
    
    [self removeTokenItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] animated:animated];
}

- (void)removeTokenItemsAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated
{
    [_items removeObjectsAtIndexes:indexes];

    NSMutableArray *indexPaths = [NSMutableArray new];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        [indexPaths addObject:indexPath];
    }];
    
    if (animated && self.window != nil) {
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    }
}

- (void)removeAllTokenItems
{
    [_items removeAllObjects];
    [_items addObject:self.textFieldItem];
    
    [self.collectionView reloadData];
}

- (NSIndexSet *)selectedItemIndexes
{
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    
    NSMutableIndexSet *indexes = [NSMutableIndexSet new];
    for (NSIndexPath *each in indexPaths) {
        [indexes addIndex:each.row];
    }
    
    return indexes;
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
    self.textFieldItem.text = text;
}

- (NSString *)text
{
    return self.textFieldItem.text;
}

#pragma mark - Configure Cells

- (void)configureTokenViewCell:(MBTokenViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBTokenItem *item = _items[indexPath.item];
    
    MBTokenCollectionItemView *itemView = nil;
    
    if (self.tokenCollectionItemViewNib) {
        //Instantiate new view from nib
        itemView = (MBTokenCollectionItemView *)[self.tokenCollectionItemViewNib instantiateWithOwner:nil options:nil].firstObject;
        NSAssert([itemView isKindOfClass:[MBTokenCollectionItemView class]], @"Unexpected item view: %@", itemView);

    } else if ([self.delegate respondsToSelector:@selector(tokenCollectionView:viewForTokenItem:)]){
        //Ask delegate for the view
        itemView = [self.delegate tokenCollectionView:self viewForTokenItem:item];
    }

    if (!itemView) {
        //Instantiate default view
        itemView = [[MBTokenCollectionItemLabel alloc] initWithTokenItem:item];
    }
    
    cell.itemView = itemView;
}

- (void)configureTokenTextFieldCell:(MBTokenTextFieldCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBTextFieldItem *item = _items[indexPath.item];
    cell.item = item;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [_items objectAtIndex:indexPath.item];
    
    if ([item isKindOfClass:[MBTokenItem class]]) {

        MBTokenViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TOKEN_VIEW_CELL_IDENTIFIER forIndexPath:indexPath];
        [self configureTokenViewCell:cell forItemAtIndexPath:indexPath];
        return cell;
        
    } else if ([item isKindOfClass:[MBTextFieldItem class]]) {
        
        MBTokenTextFieldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TEXT_FIELD_CELL_IDENTIFIER forIndexPath:indexPath];
        [self configureTokenTextFieldCell:cell forItemAtIndexPath:indexPath];
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
    CGSize size = CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
    
    id item = [_items objectAtIndex:indexPath.item];
    
    if ([item isKindOfClass:[MBTokenItem class]]) {
        
        [self configureTokenViewCell:self.tokenItemSizingCell forItemAtIndexPath:indexPath];
        size = self.tokenItemSizingCell.intrinsicContentSize;
        
    } else if ([item isKindOfClass:[MBTextFieldItem class]]) {

        [self configureTokenTextFieldCell:self.tokenTextFieldItemSizingCell forItemAtIndexPath:indexPath];
        size = self.tokenTextFieldItemSizingCell.intrinsicContentSize;
    }
    
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeThatFits:(CGSize)size forItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize fitSize = size;
    
    id item = [_items objectAtIndex:indexPath.item];
    
    if ([item isKindOfClass:[MBTokenItem class]]) {
        
        [self configureTokenViewCell:self.tokenItemSizingCell forItemAtIndexPath:indexPath];
        fitSize = [self.tokenItemSizingCell sizeThatFits:size];
        
    } else if ([item isKindOfClass:[MBTextFieldItem class]]) {
        
        [self configureTokenTextFieldCell:self.tokenTextFieldItemSizingCell forItemAtIndexPath:indexPath];
        fitSize = [self.tokenTextFieldItemSizingCell sizeThatFits:size];
    }
    
    return fitSize;
}

#pragma mark KVO Notifications

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
