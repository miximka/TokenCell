//
//  MBTokenCollectionTableViewCell.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBToken;
@protocol MBTokenCollectionTableViewCellDataSource;
@protocol MBTokenCollectionTableViewCellDelegate;
@class MBTokenCollectionTokenView;

/**
    MBTokenCollectionTableViewCell is a subclass of UITableViewCell which can present and edit tokens.
 */
@interface MBTokenCollectionTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MBTokenCollectionTableViewCellDataSource> dataSource;
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

#pragma mark - MBTokenCollectionTableViewCellDelegate

@protocol MBTokenCollectionTableViewCellDelegate <NSObject>
@required

/**
    Tells the delegate that the embedded text field has left editing mode.
    The delegate may want to use the returned text to add the token to the cell.
 */
- (void)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell didEndEditingWithText:(NSString *)text;

@optional

/**
    Tells the delegate that the text in the embedded text field has changed.
 */
- (void)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell didChangeText:(NSString *)text;

/**
    Asks the delegate if the embedded text field should process the pressing of the return button.
    Default would clear the text field.
 */
- (BOOL)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell textFieldShouldReturnWithText:(NSString *)text;

/**
    Tells the delegate that the embedded text field has just processed a delete character event while the text field was empty.
 */
- (void)tokenCollectionTableViewCellDeleteBackwardsInEmptyField:(MBTokenCollectionTableViewCell *)cell;

/**
    Tells the delegate that the content size has changed.
 */
- (void)tokenCollectionTableViewCellDidChangeContentSize:(MBTokenCollectionTableViewCell *)cell;

/**
    Tells the delegate that the embedded add button was tapped.
 */
- (void)tokenCollectionTableViewCellDidTapAddButton:(MBTokenCollectionTableViewCell *)cell;

@end

#pragma mark - MBTokenCollectionTableViewCellDelegate

@protocol MBTokenCollectionTableViewCellDataSource <NSObject>

@required
/**
    Asks the data source to provide a view to display the token.
 */
- (MBTokenCollectionTokenView *)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell viewForToken:(id<MBToken>)token;

@end
