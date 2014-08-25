//
//  MBRecipientTokenAccessoryView.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 24/07/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBRecipientToken.h"

@interface MBRecipientTokenAccessoryView : UIView

@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) MBTokenAccessoryType accessoryType;
@property (nonatomic, readonly) UIImageView *imageView;

@end
