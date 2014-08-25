//
//  MBRecipientTokenView.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 23/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBRecipientTokenView.h"
#import "MBRecipientTokenAccessoryView.h"
#import "MBRecipientToken.h"

#define HORIZONTAL_INSET    5
#define CORNER_RADIUS       15.0

@interface MBRecipientTokenView ()
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) MBRecipientTokenAccessoryView *accessoryView;
@end

@implementation MBRecipientTokenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)dealloc
{
    [self removeKVOObserverFromToken:self.token];
}

- (void)configure
{
    self.opaque = NO;
    self.layer.cornerRadius = 5.0;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = self.tintColor;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    MBRecipientTokenAccessoryView *accessoryView = [[MBRecipientTokenAccessoryView alloc] init];
    accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:accessoryView];
    _accessoryView = accessoryView;

    //Add constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel, accessoryView);
    NSMutableArray *constraints = [NSMutableArray new];
    
    NSString *constaintFormat = [NSString stringWithFormat:@"H:|-%i-[titleLabel][accessoryView]-%i-|", HORIZONTAL_INSET, HORIZONTAL_INSET];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:constaintFormat
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:titleLabel
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:titleLabel
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:accessoryView
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0]];

    [self addConstraints:constraints];
}

- (void)addKVOObserverForToken:(MBRecipientToken *)token
{
    if (!token) {
        return;
    }
    
    [self addObserver:token forKeyPath:NSStringFromSelector(@selector(email)) options:0 context:nil];
    [self addObserver:token forKeyPath:NSStringFromSelector(@selector(name)) options:0 context:nil];
    [self addObserver:token forKeyPath:NSStringFromSelector(@selector(accessoryImage)) options:0 context:nil];
}

- (void)removeKVOObserverFromToken:(MBRecipientToken *)token
{
    if (!token) {
        return;
    }
    
    [self removeObserver:token forKeyPath:NSStringFromSelector(@selector(email))];
    [self removeObserver:token forKeyPath:NSStringFromSelector(@selector(name))];
    [self removeObserver:token forKeyPath:NSStringFromSelector(@selector(accessoryImage))];
}

- (void)setToken:(MBRecipientToken *)token
{
    if (_token != token) {

        [self removeKVOObserverFromToken:_token];

        _token = token;

        [self addKVOObserverForToken:token];
        [self updateUIForToken:token];
    }
}

- (void)updateUIForToken:(MBRecipientToken *)token
{
    self.titleLabel.text = token.title;
    self.accessoryView.imageView.image = token.accessoryImage;
    self.accessoryView.accessoryType = token.accessoryType;
}

- (void)tokenDidChange
{
    MBRecipientToken *token = self.token;
    
    [self updateUIForToken:token];
    [self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

+ (UIColor *)blueTokenColor
{
    return [UIColor colorWithRed:0.216 green:0.373 blue:0.965 alpha:1];
}

+ (UIColor *)redTokenColor
{
    return [UIColor colorWithRed:1 green:0.15 blue:0.15 alpha:1];
}

#pragma mark Overridden Methods

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
        self.titleLabel.textColor = textColor;
        self.backgroundColor = bgColor;
        self.accessoryView.imageView.tintColor = textColor;
    }];
}

- (CGSize)intrinsicContentSize
{
    CGSize labelSize = [self.titleLabel intrinsicContentSize];
    CGSize accessoryViewSize = [self.accessoryView intrinsicContentSize];
    
    CGFloat width = labelSize.width + accessoryViewSize.width + HORIZONTAL_INSET * 2;
    CGFloat height = ceil(MAX(labelSize.height, accessoryViewSize.height));
    
    CGSize size = CGSizeMake(width, height);
    
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize labelSize = [self.titleLabel intrinsicContentSize];
    CGSize accessoryViewSize = [self.accessoryView intrinsicContentSize];

    //We only allow to shrink the label
    CGFloat widthWithoutLabel = accessoryViewSize.width + HORIZONTAL_INSET * 2;
    
    CGFloat minLabelWidth = labelSize.width / 2;
    if (self.titleLabel.text.length <= 3) {
        //Do not truncate too short text
        minLabelWidth = labelSize.width;
    }
    
    CGFloat width = widthWithoutLabel + minLabelWidth;
    CGFloat height = ceil(MAX(labelSize.height, accessoryViewSize.height));
    
    CGSize fitSize = CGSizeMake(MAX(width, size.width), height);
    
    return fitSize;
}

- (NSString *)description
{
    NSString *descr = [NSString stringWithFormat:@"%@, token: %@", [super description], self.token];
    return descr;
}

#pragma mark KVO Notifications

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)context
{
    if (observedObject == self.token) {
        [self tokenDidChange];
    }
}

@end
