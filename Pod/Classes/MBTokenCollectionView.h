//
//  MBTokenCollectionView.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBToken;
@protocol MBTokenCollectionViewDelegate;
@class MBTokenCollectionTokenView;

@interface MBTokenCollectionView : UIView

@property (weak, nonatomic) id<MBTokenCollectionViewDelegate> delegate;

@property (weak, nonatomic, readonly) UILabel *titleLabel;
@property (weak, nonatomic, readonly) UIButton *addButton;

#pragma mark - Manage Tokens

@property (nonatomic, readonly) NSArray *tokens;

- (void)addTokens:(NSArray *)tokens;
- (void)removeTokensAtIndexes:(NSIndexSet *)indexes;

- (void)removeAllTokens;

- (NSIndexSet *)selectedTokenIndexes;
- (void)selectTokenAtIndex:(NSInteger)index animated:(BOOL)animated;

#pragma mark - Creating Token Collection Item Views

- (void)registerNibForTokenCollectionItemView:(UINib *)nib;

#pragma mark - Display Content

- (CGSize)contentSize;

#pragma mark - Editing Text

- (void)setText:(NSString *)text;
- (NSString *)text;

- (void)startEditing;

@end

@protocol MBTokenCollectionViewDelegate <NSObject>
@required
- (MBTokenCollectionTokenView *)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView viewForToken:(id<MBToken>)token;
@optional
- (void)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView didChangeText:(NSString *)text;
- (void)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView didEndEditingText:(NSString *)text;
- (BOOL)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView textFieldShouldReturnWithText:(NSString *)text;
- (void)tokenCollectionViewDeleteBackwardsInEmptyField:(MBTokenCollectionView *)tokenCollectionView;
- (void)tokenCollectionViewDidChangeContentSize:(MBTokenCollectionView *)tokenCollectionView;
@end