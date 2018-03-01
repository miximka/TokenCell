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
    if (self.shouldInvalidateLayout) {
        return;
    }
    
    self.shouldInvalidateLayout = YES;
    __weak MBCollectionView *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.shouldInvalidateLayout = NO;
        [[weakSelf collectionViewLayout] invalidateLayout];
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
