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
@protocol MBTokenCollectionViewDataSource;
@class MBTokenCollectionTokenView;

@interface MBTokenCollectionView : UIView

@property (weak, nonatomic) id<MBTokenCollectionViewDataSource> dataSource;
@property (weak, nonatomic) id<MBTokenCollectionViewDelegate> delegate;

//Contains left supplementary view
@property (weak, nonatomic, readonly) UILabel *titleLabel;

//Contains right supplementary view
@property (nonatomic) UIView *rightView;

#pragma mark - Reloading Content

- (void)reloadData;

#pragma mark - Inserting and Deleting Tokens

- (void)insertTokensAtIndexes:(NSIndexSet *)indexes;
- (void)deleteTokensAtIndexes:(NSIndexSet *)indexes;

#pragma mark - Managing the Selection

- (NSIndexSet *)selectedTokenIndexes;
- (void)selectTokenAtIndex:(NSInteger)index animated:(BOOL)animated;

#pragma mark - Creating Token Collection Item Views

- (void)registerNibForTokenCollectionItemView:(UINib *)nib;

#pragma mark - Display Content

- (CGSize)contentSize;

#pragma mark - Editing Text

@property (nonatomic) NSString *text;

- (void)startEditing;

@end

@protocol MBTokenCollectionViewDelegate <NSObject>
@optional
- (void)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView willDisplayTokenView:(MBTokenCollectionTokenView *)view forTokenAtIndex:(NSUInteger)index;
- (void)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView didChangeText:(NSString *)text;
- (void)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView didEndEditingText:(NSString *)text;
- (BOOL)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView textFieldShouldReturnWithText:(NSString *)text;
- (void)tokenCollectionViewDeleteBackwardsInEmptyField:(MBTokenCollectionView *)tokenCollectionView;
- (void)tokenCollectionViewDidChangeContentSize:(MBTokenCollectionView *)tokenCollectionView;
@end

@protocol MBTokenCollectionViewDataSource <NSObject>
@required
- (NSUInteger)numberOfTokensInCollectionView:(MBTokenCollectionView *)tokenCollectionView;
- (MBTokenCollectionTokenView *)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView viewForTokenAtIndex:(NSUInteger)index;
@end