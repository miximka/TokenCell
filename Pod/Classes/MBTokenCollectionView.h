//
//  MBTokenCollectionView.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBTokenItem;
@class MBTokenCollectionItemView;
@protocol MBTokenCollectionViewDelegate;

@interface MBTokenCollectionView : UIView

@property (weak, nonatomic) id<MBTokenCollectionViewDelegate> delegate;

@property (weak, nonatomic, readonly) UILabel *titleLabel;
@property (weak, nonatomic, readonly) UIButton *addButton;

#pragma mark - Manage Token Items

@property (nonatomic, readonly) NSArray *tokenItems;

- (void)addTokenItem:(MBTokenItem *)item animated:(BOOL)animated;
- (void)addTokenItems:(NSArray *)items animated:(BOOL)animated;
- (void)removeTokenItem:(MBTokenItem *)item animated:(BOOL)animated;
- (void)removeTokenItemsAtIndexes:(NSIndexSet *)indexes animated:(BOOL)animated;

- (void)removeAllTokenItems;

- (NSIndexSet *)selectedItemIndexes;

#pragma mark - Creating Token Collection Item Views

- (void)registerNibForTokenCollectionItemView:(UINib *)nib;

#pragma mark - Display Content

- (CGSize)contentSize;

#pragma mark - Editing Text

- (void)setText:(NSString *)text;
- (NSString *)text;

@end

@protocol MBTokenCollectionViewDelegate <NSObject>
@optional
- (void)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView didChangeText:(NSString *)text;
- (void)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView didEndEditingText:(NSString *)text;
- (void)tokenCollectionViewTextFieldShouldReturn:(MBTokenCollectionView *)tokenCollectionView;
- (void)tokenCollectionViewDeleteBackwardsInEmptyField:(MBTokenCollectionView *)tokenCollectionView;
- (MBTokenCollectionItemView *)tokenCollectionView:(MBTokenCollectionView *)tokenCollectionView viewForTokenItem:(MBTokenItem *)tokenItem;
- (void)tokenCollectionViewDidChangeContentSize:(MBTokenCollectionView *)tokenCollectionView;
@end