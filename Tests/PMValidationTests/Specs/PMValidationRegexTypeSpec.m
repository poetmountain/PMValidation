//
//  PMValidationRegexTypeSpec.m
//  PMValidationTests
//
//  Created by Brett Walker on 3/26/14.
//  Copyright (c) 2012-2016 Poet & Mountain, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMValidationRegexType.h"

SpecBegin(PMValidationRegexType)

describe(@"PMValidationRegexType", ^{
    __block PMValidationRegexType *validator;
    __block BOOL is_valid;
    
    
    describe(@"+validatator", ^{
        
        beforeAll(^{
            validator = [PMValidationRegexType validator];
        });
        
        it(@"should return an instance of PMValidationRegexType", ^{
            expect(validator).to.beInstanceOf([PMValidationRegexType class]);
        });
    });
    
    
    describe(@"-isTextValid", ^{
        
        beforeAll(^{
            validator = [PMValidationRegexType validator];
            validator.regexString = @"o{2}";
            
            expect(validator.regexString).to.equal(@"o{2}");
            
        });
        
        describe(@", with a matching string", ^{
            before(^{
                is_valid = [validator isTextValid:@"cool"];
            });

            it(@"should return YES", ^{
                expect(is_valid).to.beTruthy();
            });
            
        });
        
        describe(@", with a string that doesn't match", ^{
            before(^{
                is_valid = [validator isTextValid:@"murakami"];
            });
            
            it(@"should return NO", ^{
                expect(is_valid).to.beFalsy();
            });
            
        });
        
    });
    
    
});


SpecEnd

