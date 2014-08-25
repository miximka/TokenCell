//
//  MBTextField.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTextField.h"
#import "MBTokenTextFieldCell.h"

@implementation MBTextField

- (void)setDelegate:(id<MBTextFieldDelegate>)object
{
    [super setDelegate:object];
}

- (id<MBTextFieldDelegate>)delegate
{
    return (id<MBTextFieldDelegate>)[super delegate];
}

- (MBTokenTextFieldCell *)parentCell
{
    UIView *view = self.superview;
    
    while (view != nil && [view isKindOfClass:[MBTokenTextFieldCell class]] == NO) {
        view = view.superview;
    }
    
    return (MBTokenTextFieldCell *)view;
}

#pragma mark - Overridden Methods

- (void)deleteBackward
{
    if (self.text.length == 0)
    {
        [[self delegate] textFieldDeleteBackwardsInEmptyField:self];
        return;
    }
    
    [super deleteBackward];
}

@end
