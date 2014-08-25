//
//  MBRecipientToken.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBToken.h"

typedef NS_ENUM(NSUInteger, MBTokenAccessoryType)
{
    kTokenNoAccessory = 0,
    kTokenAccessoryImageView,
};

@interface MBRecipientToken : NSObject <MBToken>

- (instancetype)initWithEmail:(NSString *)email name:(NSString *)name;

@property (nonatomic) NSString *email;
@property (nonatomic) NSString *name;

@property (nonatomic) MBTokenAccessoryType accessoryType;
@property (nonatomic) UIImage *accessoryImage;

@end
