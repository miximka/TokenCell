//
//  MBTokenTextFieldCell.m
//  MBTokenFieldTableViewCell
//
//  Created by miximka on 22/08/14.
//  Copyright (c) 2014 miximka. All rights reserved.
//

#import "MBTokenTextFieldCell.h"
#import "MBTextFieldToken.h"
#import "MBTextField.h"

#define MIN_CELL_WIDTH 60
#define MIN_CELL_HEIGHT 20

@interface MBTokenTextFieldCell () <MBTextFieldDelegate>
@end

@implementation MBTokenTextFieldCell
{
    BOOL _updatingItem;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTextField];
        [self registerForNotifications];
    }
    return self;
}

- (void)dealloc
{
    [self unregisterFromNotifications];
    [self setToken:nil];
}

- (void)addTextField
{
    MBTextField *textField = [[MBTextField alloc] init];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.borderStyle = UITextBorderStyleNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    
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

- (void)updateTextFieldText
{
    self.textField.text = self.token.text;
}

- (void)setToken:(MBTextFieldToken *)token
{
    if (_token != token) {

        [_token removeObserver:self forKeyPath:NSStringFromSelector(@selector(text))];
        
        _token = token;
        
        if (_token != nil) {
            [_token addObserver:self forKeyPath:NSStringFromSelector(@selector(text)) options:0 context:nil];
        }
        
        [self updateTextFieldText];
    }
}

#pragma mark - Overridden Methods

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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.token.textBeginEditingHandler != nil) {
        self.token.textBeginEditingHandler();
    }
}

- (void)textFieldDeleteBackwardsInEmptyField:(MBTextField *)textField
{
    if (self.token.deleteBackwardsInEmptyFieldHandler != nil) {
        self.token.deleteBackwardsInEmptyFieldHandler();
    }
}

- (void)clearTextFieldContent
{
    _updatingItem = YES;
    self.token.text = @"";
    self.textField.text = @"";
    _updatingItem = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *text = self.textField.text;

    //Automatically cleanup the text field content
    [self clearTextFieldContent];

    if (self.token.textEndEditingHandler != nil) {
        self.token.textEndEditingHandler(text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shouldReturn = YES;

    NSString *text = textField.text;

    //Automatically cleanup the text field content _before_ calling the handler to workaround layout problems with
    //UICollectionView where layout won't be performed correctly if -invalidateLayout called multiple times in a very short period of time
    [self clearTextFieldContent];

    if (self.token.textFieldShouldReturnHandler != nil) {
        shouldReturn = self.token.textFieldShouldReturnHandler(text);
    }

    return shouldReturn;
}

#pragma mark - Notifications

- (void)textDidChangeNotification:(NSNotification *)notification
{
    _updatingItem = YES;
    self.token.text = self.textField.text;
    _updatingItem = NO;
    
    if (self.token.textDidChangeHandler != nil) {
        self.token.textDidChangeHandler(self.textField.text);
    }
}

#pragma mark KVO Notifications

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(text))] && !_updatingItem) {
        [self updateTextFieldText];
    }
}

@end
