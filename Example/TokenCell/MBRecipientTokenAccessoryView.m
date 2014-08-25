//
//  MBRecipientTokenAccessoryView.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 24/07/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBRecipientTokenAccessoryView.h"

#define DEFAULT_ACCESSORY_EDGE_LENGTH  15
#define INTER_ICON_SPACE  2

@interface MBRecipientTokenAccessoryView ()
@end

@implementation MBRecipientTokenAccessoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    _edgeInsets = UIEdgeInsetsMake(0, INTER_ICON_SPACE, 0, 0);
    
    _imageView = [[UIImageView alloc] initWithImage:nil];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (NSArray *)generateLayoutConstraintsForAccessorySubview:(UIView *)view anchorView:(UIView *)anchorView
{
    NSMutableArray *constraints = [NSMutableArray new];
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    
    NSString *hConstraintFormat = [NSString stringWithFormat:@"H:|-%i-[view]", (int)self.edgeInsets.left];
    if (anchorView) {
        views = NSDictionaryOfVariableBindings(view, anchorView);
        hConstraintFormat = [NSString stringWithFormat:@"H:[anchorView]-%i-[view]", INTER_ICON_SPACE];
    }
    
    if (view.intrinsicContentSize.width == UIViewNoIntrinsicMetric) {
        //View does not have intrinsic width, so use the default width

        NSString *widthConstraintFormat = [NSString stringWithFormat:@"[view(==%i)]", DEFAULT_ACCESSORY_EDGE_LENGTH];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:widthConstraintFormat
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
    }
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:hConstraintFormat
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    
    if (view.intrinsicContentSize.height == UIViewNoIntrinsicMetric) {
        NSString *vConstraintFormat = [NSString stringWithFormat:@"V:[view(==%i)]", DEFAULT_ACCESSORY_EDGE_LENGTH];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vConstraintFormat
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
    }
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:view
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0]];
    
    return constraints;
}

- (void)addAccessorySubview:(UIView *)view
{
    UIView *anchorView = self.subviews.lastObject;
    [self addSubview:view];
    
    NSArray *constraints = [self generateLayoutConstraintsForAccessorySubview:view anchorView:anchorView];
    [self addConstraints:constraints];
}

- (void)rebuildIconViewHierarchyIfNeeded
{
    if (self.accessoryType == kTokenAccessoryImageView) {
        [self addAccessorySubview:_imageView];
    } else {
        [_imageView removeFromSuperview];
    }
}

- (void)setAccessoryType:(MBTokenAccessoryType)accessoryType
{
    if (_accessoryType != accessoryType) {
        _accessoryType = accessoryType;
        
        [self rebuildIconViewHierarchyIfNeeded];
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSizeForSubviews:(NSArray *)subviews
{
    if (subviews.count == 0)
        return CGSizeZero;

    UIEdgeInsets edgeInsets = self.edgeInsets;
    CGFloat width = 0;
    CGFloat height = 0;

    //Take edge insets into account
    width = edgeInsets.left + edgeInsets.right;
    height = edgeInsets.top + edgeInsets.bottom;

    CGFloat maxSubviewHeight = 0;
    
    for (UIView *view in subviews) {
        
        CGFloat viewWidth = view.intrinsicContentSize.width;
        if (viewWidth == UIViewNoIntrinsicMetric) {
            viewWidth = DEFAULT_ACCESSORY_EDGE_LENGTH;
        }

        CGFloat viewHeight = view.intrinsicContentSize.height;
        if (viewHeight != UIViewNoIntrinsicMetric) {
            maxSubviewHeight = MAX(maxSubviewHeight, viewHeight);
        }

        width += viewWidth;
    }
    
    width += INTER_ICON_SPACE * (subviews.count - 1);
    
    if (maxSubviewHeight != 0) {
        height += maxSubviewHeight;
    } else {
        height += DEFAULT_ACCESSORY_EDGE_LENGTH;
    }
    
    return CGSizeMake(width, height);
}

#pragma mark Overridden Methods

- (CGSize)intrinsicContentSize
{
    NSMutableArray *subviews = [NSMutableArray new];

    if (self.accessoryType == kTokenAccessoryImageView) {
        [subviews addObject:self.imageView];
    }
    
    return [self intrinsicContentSizeForSubviews:subviews];
}

@end
