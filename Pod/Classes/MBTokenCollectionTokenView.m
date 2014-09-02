//
//  MBTokenCollectionTokenView.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenCollectionTokenView.h"
#import "MBTokenViewCell.h"

#define CORNER_RADIUS 15.0

@implementation MBTokenCollectionTokenView

- (MBTokenViewCell *)parentCell
{
    UIView *view = self.superview;
    
    while (view != nil && ![view isKindOfClass:[MBTokenViewCell class]]) {
        view = view.superview;
    }
    
    return (MBTokenViewCell *)view;
}

- (void)invalidateIntrinsicContentSize
{
    [super invalidateIntrinsicContentSize];
    [self.parentCell itemViewDidInvalidateIntrinsicContentSize];
}

@end
