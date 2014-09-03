//
//  MBTokenViewCell.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBTokenCollectionTokenView;

@interface MBTokenViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet MBTokenCollectionTokenView *tokenView;

- (void)itemViewDidInvalidateIntrinsicContentSize;

@end
