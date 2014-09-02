//
//  MBTokenCollectionItemLabel.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenCollectionItemLabel.h"
#import "MBToken.h"

#define HORIZONTAL_INSET 2

@interface MBTokenCollectionItemLabel ()
@property (weak, nonatomic) UILabel *label;
@end

@implementation MBTokenCollectionItemLabel

- (instancetype)initWithToken:(id<MBToken>)token
{
    self = [super init];
    if (self) {
        _token = token;
        [self addLabel];
        [self updateLabelText];
        self.layer.cornerRadius = 5.0;
    }
    return self;
}

- (void)addLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:label];
    
    NSString *format = [NSString stringWithFormat:@"H:|-%i-[label]-%i-|", HORIZONTAL_INSET, HORIZONTAL_INSET];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
    
    _label = label;
}

- (void)updateLabelText
{
    NSString *title = _token.title;
    self.label.text = title;
}

#pragma mark - Overridden Methods

- (CGSize)intrinsicContentSize
{
    CGSize size = self.label.intrinsicContentSize;
    size.width += HORIZONTAL_INSET * 2;
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize fitSize = [self.label sizeThatFits:size];
    fitSize.width += HORIZONTAL_INSET * 2;
    return fitSize;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    UIColor *bgColor = nil;
    UIColor *textColor = self.tintColor;
    
    if (selected) {
        bgColor = self.tintColor;
        textColor = [UIColor whiteColor];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.label.textColor = textColor;
        self.backgroundColor = bgColor;
    }];
}

@end
