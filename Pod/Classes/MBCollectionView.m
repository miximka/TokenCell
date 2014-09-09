//
//  MBCollectionView.m
//  Pods
//
//  Created by Maksim Bauer on 09/09/14.
//
//

#import "MBCollectionView.h"

@implementation MBCollectionView

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
