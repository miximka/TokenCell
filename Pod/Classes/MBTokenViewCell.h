//
//  MBTokenViewCell.h
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBTokenCollectionItemView;

@interface MBTokenViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet MBTokenCollectionItemView *itemView;

- (void)itemViewDidInvalidateIntrinsicContentSize;

@end
