//
//  MBTextFieldToken.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBTextFieldToken : NSObject

@property (nonatomic, nullable) NSString *text;
@property (nonatomic, nullable, copy) void(^textBeginEditingHandler)(void);
@property (nonatomic, nullable, copy) void(^textDidChangeHandler)(NSString *text);
@property (nonatomic, nullable, copy) void(^textEndEditingHandler)(NSString *text);
@property (nonatomic, nullable, copy) BOOL(^textFieldShouldReturnHandler)(NSString *text);
@property (nonatomic, nullable, copy) void(^deleteBackwardsInEmptyFieldHandler)(void);
@end

NS_ASSUME_NONNULL_END
