//
//  MBTextField.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTextField.h"

@implementation MBTextField

#pragma mark - Overridden Methods

//Overriden private method - required as since iOS8 -deleteBackward does not get called any more
- (BOOL)keyboardInputShouldDelete:(UITextField *)textField
{
    if (self.text.length == 0) {
        [[self delegate] textFieldDeleteBackwardsInEmptyField:self];
    }

    return YES;
}

@end
