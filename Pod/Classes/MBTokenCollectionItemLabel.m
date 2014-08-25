//
//  MBTokenCollectionItemLabel.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenCollectionItemLabel.h"
#import "MBTokenItem.h"

@interface MBTokenCollectionItemLabel ()
@property (weak, nonatomic) UILabel *label;
@end

@implementation MBTokenCollectionItemLabel

- (instancetype)initWithTokenItem:(MBTokenItem *)tokenItem
{
    self = [super init];
    if (self) {
        _tokenItem = tokenItem;
        [self addLabel];
        [self updateLabelText];
    }
    return self;
}

- (void)addLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:label];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
    
    _label = label;
}

- (void)updateLabelText
{
    NSString *title = _tokenItem.title;
    self.label.text = title;
}

#pragma mark - Overridden Methods

- (CGSize)intrinsicContentSize
{
    return self.label.intrinsicContentSize;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self.label sizeThatFits:size];
}

@end
