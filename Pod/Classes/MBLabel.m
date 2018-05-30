//
//  MBLabel.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 30/05/18.
//  Copyright (c) 2018 miximka. All rights reserved.
//

#import "MBLabel.h"

@implementation MBLabel

- (void)invalidateIntrinsicContentSize {
    [super invalidateIntrinsicContentSize];
    if (_didInvalidateIntrinsicContentSize != nil) {
        _didInvalidateIntrinsicContentSize();
    }
}

@end
