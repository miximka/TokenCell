//
//  MBSimpleTokenView.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenCollectionTokenView.h"

@class MBSimpleToken;

@interface MBSimpleTokenView : MBTokenCollectionTokenView

- (instancetype)initWithToken:(MBSimpleToken *)token;

@property (nonatomic) MBSimpleToken *token;

@end
