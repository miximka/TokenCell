//
//  MBTextFieldItem.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBTextFieldItem : NSObject

@property (nonatomic) NSString *text;
@property (nonatomic, copy) void(^textBeginEditingHandler)();
@property (nonatomic, copy) void(^textDidChangeHandler)(NSString *text);
@property (nonatomic, copy) void(^textEndEditingHandler)(NSString *text);
@property (nonatomic, copy) void(^deleteBackwardsInEmptyFieldHandler)();
@end
