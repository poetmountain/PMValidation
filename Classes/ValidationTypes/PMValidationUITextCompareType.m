//
//  PMValidationUITextCompareType.m
//  
//
//  Created by Brett Walker on 6/9/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationUITextCompareType.h"

@implementation PMValidationUITextCompareType

@synthesize lastStringValue;

#pragma mark - Lifecycle methods

-(id)init {
    
    self = [super init];
    if (self) {
        self.sendsUpdates = YES;
    }
    
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [lastStringValue release];
    
    [super dealloc];
}


#pragma mark - Notification methods


-(BOOL)isTextValid:(NSString *)text {
    
    self.isValid = [text isEqualToString:self.comparisonString];
    
    self.lastStringValue = text;
    
    return self.isValid;
}


- (void) registerTextFieldToMatch:(UITextField *)textField {
    
    // add listener for object which will pass on text changes to validator unit
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChangeNotification:)                                                 
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField];
    self.comparisonString = textField.text;
    
}


- (void)registerTextViewToMatch:(UITextView *)textView {
    
    // add listener for object which will pass on text changes to validator unit
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChangeNotification:)                                                 
                                                 name:UITextViewTextDidChangeNotification
                                               object:textView];
    self.comparisonString = textView.text;
}


#pragma mark - Notification methods

- (void) textDidChangeNotification:(NSNotification *)notification {
    
    
    if (notification.name == UITextFieldTextDidChangeNotification) {
        UITextField *text_field = (UITextField *)notification.object;
        self.comparisonString = text_field.text;
    } else if (notification.name == UITextViewTextDidChangeNotification) {
        UITextView *text_view = (UITextView *)notification.object;
        self.comparisonString = text_view.text;
    }
    
    // because we are observing a UI text object to match against, we have to manually re-validate here
    // otherwise, isValid could return YES when it actually isn't
    self.isValid = [self isTextValid:self.lastStringValue];
        
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:self.isValid] forKey:@"status"];
    [[NSNotificationCenter defaultCenter] postNotificationName:PMValidationUpdateNotification object:self userInfo:dict];

}


#pragma mark - Class methods

// returns a new, autoreleased instance of PMValidationUITextMatchType
+ (id) validator {
    
    PMValidationUITextCompareType *val = [[[PMValidationUITextCompareType alloc] init] autorelease];
    
    return val;
    
}


+ (NSString *)type {
    
    return @"PMValidationTypeUITextMatch";
}


@end
