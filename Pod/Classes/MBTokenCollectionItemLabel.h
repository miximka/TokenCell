//
//  MBTokenCollectionItemLabel.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenCollectionItemView.h"

@interface MBTokenCollectionItemLabel : MBTokenCollectionItemView

- (instancetype)initWithTokenItem:(MBTokenItem *)tokenItem;

@property (nonatomic) MBTokenItem *tokenItem;

@end
