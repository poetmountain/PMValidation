//
//  PMValidationStringCompareTypeSpec.m
//  PMValidationTests
//
//  Created by Brett Walker on 3/26/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMValidationStringCompareType.h"


SpecBegin(PMValidationStringCompareType)

describe(@"PMValidationStringCompareType", ^{
    __block PMValidationStringCompareType *validator;
    __block BOOL is_valid;

    describe(@"+validatator", ^{
        
        beforeAll(^{
            validator = [PMValidationStringCompareType validator];
        });
        
        it(@"should return an instance of PMValidationStringCompareType", ^{
            expect(validator).to.beInstanceOf([PMValidationStringCompareType class]);
        });
    });
    
    
    describe(@"-isTextValid", ^{

        describe(@"when comparisonType is kPMValidationComparisonTypeEquals", ^{
            beforeAll(^{
                validator = [PMValidationStringCompareType validator];
                validator.comparisonString = @"cool";
                
                expect(validator.comparisonString).to.equal(@"cool");
                
            });
            
            describe(@", and different text", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"not cool"];
                });
                
                
                it(@"should return NO", ^{
                    expect(is_valid).to.beFalsy();
                });
                
                it(@"should add correct error state to validationStates", ^{
                    expect(validator.validationStates).to.contain(kPMValidationStatusInvalid);
                });
            });
            
            describe(@", and the same text", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"cool"];
                });
                
                it(@"should return YES", ^{
                    expect(is_valid).to.beTruthy();
                });
            });
            
        });
        
        
        
        describe(@"when comparisonType is kPMValidationComparisonTypeNotEquals", ^{
            beforeAll(^{
                validator = [PMValidationStringCompareType validator];
                validator.comparisonString = @"cool";
                validator.comparisonType = kPMValidationComparisonTypeNotEquals;
                
                expect(validator.comparisonString).to.equal(@"cool");
                expect(validator.comparisonType).to.equal(kPMValidationComparisonTypeNotEquals);
                
            });
            
            describe(@", and the same text", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"cool"];
                });
                
                
                it(@"should return NO", ^{
                    expect(is_valid).to.beFalsy();
                });
                
                it(@"should add correct error state to validationStates", ^{
                    expect(validator.validationStates).to.contain(kPMValidationStatusInvalid);
                });
            });
            
            describe(@", and different text", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"not cool"];
                });
                
                it(@"should return YES", ^{
                    expect(is_valid).to.beTruthy();
                });
            });
            
        });
        
    });
    
    
});

SpecEnd