//
//  MBTokenTextFieldCell.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenTextFieldCell.h"
#import "MBTextFieldItem.h"
#import "MBTextField.h"

#define MIN_CELL_WIDTH 60
#define MIN_CELL_HEIGHT 20

@interface MBTokenTextFieldCell () <MBTextFieldDelegate>
@end

@implementation MBTokenTextFieldCell
{
    BOOL _editing;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTextField];
    }
    return self;
}

- (void)dealloc
{
    [self unregisterFromNotifications];
}

- (void)addTextField
{
    MBTextField *textField = [[MBTextField alloc] init];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    textField.delegate = self;

    [self addSubview:textField];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textField]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textField)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textField]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textField)]];
    
    _textField = textField;
}

- (void)unregisterFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChangeNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.textField];
}

- (void)setItem:(MBTextFieldItem *)item
{
    _item = item;
    self.textField.text = item.text;
}

#pragma mark - Overridden Methods

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if (self.window != nil) {
        [self registerForNotifications];
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize size = self.textField.intrinsicContentSize;

    if (size.width < MIN_CELL_WIDTH)
        size.width = MIN_CELL_WIDTH;
    
    if (size.height < MIN_CELL_HEIGHT)
        size.height = MIN_CELL_HEIGHT;

    return size;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize fitSize = [self.textField sizeThatFits:size];
    
    if (fitSize.width < MIN_CELL_WIDTH)
        fitSize.width = MIN_CELL_WIDTH;
    
    if (fitSize.height < MIN_CELL_HEIGHT)
        fitSize.height = MIN_CELL_HEIGHT;
    
    return fitSize;
}

#pragma mark - MBTextFieldDelegate

- (void)textFieldDeleteBackwardsInEmptyField:(MBTextField *)textField
{
    if (self.item.deleteBackwardsInEmptyFieldHandler != nil) {
        self.item.deleteBackwardsInEmptyFieldHandler();
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *text = self.textField.text;
    
    self.item.text = @"";
    self.textField.text = @"";
    
    if (self.item.textEndEditingHandler != nil) {
        self.item.textEndEditingHandler(text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Notifications

- (void)textDidChangeNotification:(NSNotification *)notification
{
    self.item.text = self.textField.text;
}

@end
