//
//  MBCollectionView.h
//  Pods
//
//  Created by Maksim Bauer on 09/09/14.
//
//

#import <UIKit/UIKit.h>

@interface MBCollectionView : UICollectionView

- (void)setNeedsInvalidateLayout;

@end

@protocol MBCollectionViewDelegate <UICollectionViewDelegate>
- (void)collectionViewDidTouchInside:(MBCollectionView *)collectionView;
@end