//
//  MBTokenCollectionTableViewCell.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBToken;
@class MBTokenCollectionTokenView;
@protocol MBTokenCollectionTableViewCellDelegate;

/**
    MBTokenCollectionTableViewCell is a subclass of UITableViewCell which can present and edit tokens.
 */
@interface MBTokenCollectionTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MBTokenCollectionTableViewCellDelegate> delegate;

/**
    Holds the main label of the cell
 */
@property (nonatomic, readonly) UILabel *titleLabel;

#pragma mark - Handling Tokens

/**
    Add token to the receiver.
 */
- (void)addTokens:(NSArray *)tokens;

/**
    Remove tokens at specified indexes
 */
- (void)removeTokensAtIndexes:(NSIndexSet *)indexes;

#pragma mark - Handling Token Selection

/**
    Returns the indexes of selected tokens.
 */
- (NSIndexSet *)selectedTokenIndexes;

/**
    Selects the token at the specified index.
 */
- (void)selectTokenAtIndex:(NSInteger)index animated:(BOOL)animated;

#pragma mark - Display Content

/**
    The size of the content. Can be used to determine optimal receiver height.
 */
- (CGSize)contentSize;

#pragma mark - Editing Text

/**
    The text displayed by the embedded editor text field
 */
@property (nonatomic) NSString *text;

/**
    Makes the embedded text field first responder, i.e. begins editing
 */
- (void)startEditing;

@end

@protocol MBTokenCollectionTableViewCellDelegate <NSObject>
- (void)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell didEndEditingWithText:(NSString *)text;
@optional
- (void)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell didChangeText:(NSString *)text;
- (void)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell textFieldShouldReturnWithText:(NSString *)text;
- (void)tokenCollectionTableViewCellDeleteBackwardsInEmptyField:(MBTokenCollectionTableViewCell *)cell;
- (MBTokenCollectionTokenView *)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell viewForToken:(id<MBToken>)token;
- (void)tokenCollectionTableViewCellDidChangeContentSize:(MBTokenCollectionTableViewCell *)cell;
- (void)tokenCollectionTableViewCellDidTapAddButton:(MBTokenCollectionTableViewCell *)cell;
@end
