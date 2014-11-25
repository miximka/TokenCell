//
//  MBTextField.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBTextField;

@protocol MBTextFieldDelegate <UITextFieldDelegate>
- (void)textFieldDeleteBackwardsInEmptyField:(MBTextField *)textField;
@end

@interface MBTextField : UITextField

@property (nonatomic, assign) id<MBTextFieldDelegate> delegate;

@end
