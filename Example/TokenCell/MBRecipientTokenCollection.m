//
//  MBRecipientTokenCollection.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBRecipientTokenCollection.h"

@implementation MBRecipientTokenCollection
{
    NSMutableArray *_tokens;
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _title = title;
        _tokens = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Handling Tokens

- (NSArray *)tokens
{
    return _tokens;
}

- (void)addToken:(MBRecipientToken *)token
{
    [_tokens addObject:token];
}

- (void)removeTokensAtIndexes:(NSIndexSet *)indexes
{
    [_tokens removeObjectsAtIndexes:indexes];
}

@end
