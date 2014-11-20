//
//  MBTokenCollectionTokenView.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBTokenItem;

@interface MBTokenCollectionTokenView : UIView

//Do not set selection status manually - use the selection methods of MBTokenCollectionTableViewCell
@property(nonatomic, getter=isSelected) BOOL selected;

@end
