//
//  MBTokenTextFieldCell.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBTextFieldToken;

@interface MBTokenTextFieldCell : UICollectionViewCell

@property (nonatomic, readonly) UITextField *textField;

/**
    Represented token
 */
@property (nonatomic) MBTextFieldToken *token;

- (void)startEditing;

@end
