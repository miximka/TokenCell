//
//  MBRecipientToken.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBRecipientToken.h"

@implementation MBRecipientToken

- (instancetype)initWithEmail:(NSString *)email name:(NSString *)name
{
    self = [super init];
    if (self) {
        _email = email;
        _name = name;
    }
    return self;
}

- (NSString *)title
{
    if (self.name.length > 0)
        return self.name;
    
    return self.email;
}

@end
