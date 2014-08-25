//
//  MBTextField.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBTextField;
@class MBTokenTextFieldCell;
@protocol MBTextFieldDelegate;

@interface MBTextField : UITextField

- (void)setDelegate:(id<MBTextFieldDelegate>)object;
- (id<MBTextFieldDelegate>)delegate;

/**
    Returns parent cell view.
 */
- (MBTokenTextFieldCell *)parentCell;

@end

@protocol MBTextFieldDelegate <UITextFieldDelegate>
- (void)textFieldDeleteBackwardsInEmptyField:(MBTextField *)textField;
@end
