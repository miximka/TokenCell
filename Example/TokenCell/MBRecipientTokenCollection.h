//
//  MBRecipientTokenCollection.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBRecipientToken;

@interface MBRecipientTokenCollection : NSObject

- (instancetype)initWithTitle:(NSString *)title;

@property (nonatomic) NSString *title;

#pragma mark - Handling Tokens

@property (nonatomic, readonly) NSArray *tokens;

- (void)addToken:(MBRecipientToken *)token;
- (void)removeTokensAtIndexes:(NSIndexSet *)indexes;

@end
