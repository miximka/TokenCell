//
//  MBCollectionView.m
//  Pods
//
//  Created by Maksim Bauer on 09/09/14.
//
//

#import "MBCollectionView.h"

@interface MBCollectionView ()
@property (nonatomic) BOOL shouldInvalidateLayout;
@end

@implementation MBCollectionView

- (void)setNeedsInvalidateLayout
{
    if (_shouldInvalidateLayout) {
        return;
    }
    
    _shouldInvalidateLayout = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _shouldInvalidateLayout = NO;
        [[self collectionViewLayout] invalidateLayout];
    });
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (touches.count == 1) {
        UITouch *touch = touches.anyObject;
        if (touch.view == self) {
            [(id<MBCollectionViewDelegate>)self.delegate collectionViewDidTouchInside:self];
        }
    }
}

@end
