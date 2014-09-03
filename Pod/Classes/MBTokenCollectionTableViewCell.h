//
//  MBTokenCollectionTableViewCell.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBToken;
@class MBTokenCollectionView;
@class MBTokenCollectionTokenView;
@protocol MBTokenCollectionTableViewCellDelegate;

@interface MBTokenCollectionTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet MBTokenCollectionView *collectionView;
@property (weak, nonatomic) id<MBTokenCollectionTableViewCellDelegate> delegate;

@property (nonatomic, readonly) UILabel *titleLabel;

#pragma mark - Handling Tokens

- (void)addTokens:(NSArray *)tokens animated:(BOOL)animated;
- (void)removeTokensAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated;

- (NSIndexSet *)selectedTokenIndexes;

#pragma mark - Display Content

- (CGSize)contentSize;

#pragma mark - Editing Text

- (void)setEditingText:(NSString *)text;
- (NSString *)editingText;

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
