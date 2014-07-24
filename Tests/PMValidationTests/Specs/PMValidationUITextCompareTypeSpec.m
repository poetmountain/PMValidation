//
//  PMValidationUITextCompareTypeSpec.m
//  PMValidationTests
//
//  Created by Brett Walker on 3/26/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMValidationUITextCompareType.h"

SpecBegin(PMValidationUITextCompareType)

describe(@"PMValidationUITextCompareType", ^{
    __block PMValidationUITextCompareType *validator;
    
    
    describe(@"+validatator", ^{
        
        beforeAll(^{
            validator = [PMValidationUITextCompareType validator];
        });
        
        it(@"should return an instance of PMValidationRegexType", ^{
            expect(validator).to.beInstanceOf([PMValidationUITextCompareType class]);
        });
    });
    
    
    describe(@", register a UITextField", ^{
        __block UITextField *text_field;
        
        describe(@"when comparisonType is kPMValidationComparisonTypeEquals", ^{
        
            beforeAll(^{
                validator = [PMValidationUITextCompareType validator];
                text_field = [[UITextField alloc] init];
                validator.lastStringValue = @"cool";
                [validator registerTextFieldToMatch:text_field];
                
            });
            
            it(@"should return YES when UITextField updates with valid text", ^{
                
                __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:PMValidationUpdateNotification object:validator queue:nil usingBlock:^(NSNotification *note) {
                    
                    expect(note.object).to.beIdenticalTo(validator);
                    expect(note.userInfo[@"status"]).to.beTruthy();
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:observer];
                    
                }];
                
                NSNotification *note = [[NSNotification alloc] initWithName:UITextFieldTextDidChangeNotification object:text_field userInfo:nil];
                expect(^{
                    text_field.text = @"cool";
                    [validator textDidChangeNotification:note];
                }).to.notify(PMValidationUpdateNotification);
                
            });
            
            
            it(@"should return NO when UITextField updates with invalid text", ^{
                
                __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:PMValidationUpdateNotification object:validator queue:nil usingBlock:^(NSNotification *note) {
                    
                    expect(note.object).to.beIdenticalTo(validator);
                    expect(note.userInfo[@"status"]).to.beFalsy();
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:observer];
                    
                }];
                
                NSNotification *note = [[NSNotification alloc] initWithName:UITextFieldTextDidChangeNotification object:text_field userInfo:nil];
                expect(^{
                    text_field.text = @"uncool";
                    [validator textDidChangeNotification:note];
                }).to.notify(PMValidationUpdateNotification);
                
            });
            
        });
 
        
        describe(@"when comparisonType is kPMValidationComparisonTypeNotEquals", ^{
            
            beforeAll(^{
                validator = [PMValidationUITextCompareType validator];
                validator.comparisonType = kPMValidationComparisonTypeNotEquals;
                text_field = [[UITextField alloc] init];
                validator.lastStringValue = @"cool";
                [validator registerTextFieldToMatch:text_field];
                
            });
            
            it(@"should return YES when UITextField updates with different text", ^{
                
                __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:PMValidationUpdateNotification object:validator queue:nil usingBlock:^(NSNotification *note) {
                    
                    expect(note.object).to.beIdenticalTo(validator);
                    expect(note.userInfo[@"status"]).to.beTruthy();
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:observer];
                    
                }];
                
                NSNotification *note = [[NSNotification alloc] initWithName:UITextFieldTextDidChangeNotification object:text_field userInfo:nil];
                expect(^{
                    text_field.text = @"not cool";
                    [validator textDidChangeNotification:note];
                }).to.notify(PMValidationUpdateNotification);
                
            });
            
            
            it(@"should return NO when UITextField updates with the same text", ^{
                
                __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:PMValidationUpdateNotification object:validator queue:nil usingBlock:^(NSNotification *note) {
                    
                    expect(note.object).to.beIdenticalTo(validator);
                    expect(note.userInfo[@"status"]).to.beFalsy();
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:observer];
                    
                }];
                
                NSNotification *note = [[NSNotification alloc] initWithName:UITextFieldTextDidChangeNotification object:text_field userInfo:nil];
                expect(^{
                    text_field.text = @"cool";
                    [validator textDidChangeNotification:note];
                }).to.notify(PMValidationUpdateNotification);
                
            });
            
        });
        
    });
    
    
    
    describe(@", register a UITextView", ^{
        __block UITextView *text_view;
        
        beforeAll(^{
            validator = [PMValidationUITextCompareType validator];
            text_view = [[UITextView alloc] init];
            validator.lastStringValue = @"cool";
            [validator registerTextViewToMatch:text_view];
            
        });
        
        it(@"should return YES when UITextView updates with valid text", ^{
            
            __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:PMValidationUpdateNotification object:validator queue:nil usingBlock:^(NSNotification *note) {

                expect(note.object).to.beIdenticalTo(validator);
                expect(note.userInfo[@"status"]).to.beTruthy();
                
                [[NSNotificationCenter defaultCenter] removeObserver:observer];
                
            }];
            
            NSNotification *note = [[NSNotification alloc] initWithName:UITextViewTextDidChangeNotification object:text_view userInfo:nil];
            expect(^{
                text_view.text = @"cool";
                [validator textDidChangeNotification:note];
            }).to.notify(PMValidationUpdateNotification);
            
        });
        
        
        it(@"should return NO when UITextView updates with invalid text", ^{
            
            __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:PMValidationUpdateNotification object:validator queue:nil usingBlock:^(NSNotification *note) {
                
                expect(note.object).to.beIdenticalTo(validator);
                expect(note.userInfo[@"status"]).to.beFalsy();
                
                [[NSNotificationCenter defaultCenter] removeObserver:observer];
                
            }];
            
            NSNotification *note = [[NSNotification alloc] initWithName:UITextViewTextDidChangeNotification object:text_view userInfo:nil];
            expect(^{
                text_view.text = @"uncool";
                [validator textDidChangeNotification:note];
            }).to.notify(PMValidationUpdateNotification);
            
        });
        
        
    });

    
    
});


SpecEnd

