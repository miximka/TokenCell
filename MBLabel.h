//
//  MBLabel.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 30/05/18.
//  Copyright (c) 2018 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBLabel : UILabel

@property (nonatomic, copy, nullable) void(^didInvalidateIntrinsicContentSize)(void);

@end
