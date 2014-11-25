//
//  MBTokenCollectionViewTokenLayout.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 21/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBTokenCollectionViewLayout;

@interface MBTokenCollectionViewTokenLayout : UICollectionViewLayout
@end

@protocol MBTokenCollectionViewDelegateTokenLayout <UICollectionViewDelegate>
- (CGRect)collectionViewTopLeftContentFreeRect:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout;
- (CGRect)collectionViewTopRightContentFreeRect:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout intrinsicItemSizeAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeThatFits:(CGSize)size forItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionViewShouldOccupyRemainingFreeSpace:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout forItemAtIndexPath:(NSIndexPath *)indexPath;
@end
