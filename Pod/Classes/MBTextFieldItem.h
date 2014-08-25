//
//  MBTextFieldItem.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MBTextFieldItemTextEndEditingHandler)(NSString *text);
typedef void(^MBTextFieldItemDeleteBackwardsInEmptyFieldHandler)();

@interface MBTextFieldItem : NSObject

@property (nonatomic) NSString *text;
@property (nonatomic, copy) MBTextFieldItemTextEndEditingHandler textEndEditingHandler;
@property (nonatomic, copy) MBTextFieldItemDeleteBackwardsInEmptyFieldHandler deleteBackwardsInEmptyFieldHandler;
@end
