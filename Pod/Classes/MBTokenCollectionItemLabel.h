//
//  MBTokenCollectionItemLabel.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenCollectionTokenView.h"
#import "MBToken.h"

@interface MBTokenCollectionItemLabel : MBTokenCollectionTokenView

- (instancetype)initWithToken:(id<MBToken>)token;

@property (nonatomic) id<MBToken> token;

@end
