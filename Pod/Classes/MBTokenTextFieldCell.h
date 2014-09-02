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

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) MBTextFieldToken *token;

@end
