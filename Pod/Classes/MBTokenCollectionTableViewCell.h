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
@class MBTokenCollectionItemView;
@protocol MBTokenCollectionTableViewCellDelegate;

@interface MBTokenCollectionTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet MBTokenCollectionView *collectionView;
@property (weak, nonatomic) id<MBTokenCollectionTableViewCellDelegate> delegate;

- (void)setTitle:(NSString *)title;
- (NSString *)title;

#pragma mark - Handling Tokens

- (void)addTokens:(NSArray *)tokens animated:(BOOL)animated;
- (void)removeTokensAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated;

- (NSIndexSet *)selectedTokenIndexes;

#pragma mark - Display Content

- (CGSize)contentSize;

@end

@protocol MBTokenCollectionTableViewCellDelegate <NSObject>
- (void)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell didEndEditingWithText:(NSString *)text;
@optional
- (void)tokenCollectionTableViewCellDeleteBackwardsInEmptyField:(MBTokenCollectionTableViewCell *)cell;
- (MBTokenCollectionItemView *)tokenCollectionTableViewCell:(MBTokenCollectionTableViewCell *)cell viewForToken:(id<MBToken>)token;
- (void)tokenCollectionTableViewCellDidChangeContentSize:(MBTokenCollectionTableViewCell *)cell;
- (void)tokenCollectionTableViewCellDidTapAddButton:(MBTokenCollectionTableViewCell *)cell;
@end