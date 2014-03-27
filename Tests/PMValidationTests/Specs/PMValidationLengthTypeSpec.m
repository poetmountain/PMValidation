//
//  PMValidationLengthTypeSpec.m
//  PMValidationTests
//
//  Created by Brett Walker on 3/26/14.
//  Copyright (c) 2014 Poet & Mountain, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMValidationLengthType.h"


SpecBegin(PMValidationLengthType)

describe(@"PMValidationLengthType", ^{
    __block PMValidationLengthType *validator;
    __block BOOL is_valid;


    describe(@"+validatator", ^{
    
        beforeAll(^{
            validator = [PMValidationLengthType validator];
        });
        
        it(@"should return an instance of PMValidationLengthType", ^{
            expect(validator).to.beInstanceOf([PMValidationLengthType class]);
        });
    });
    
    describe(@"-isTextValid", ^{
        
        describe(@"when minimumCharacters is specified", ^{
            beforeAll(^{
                validator = [PMValidationLengthType validator];
                [validator setMinimumCharacters:4];

                expect(validator.minimumCharacters).to.equal(4);

            });
            
            describe(@", and invalid text", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"hey"];
                });
                

                it(@"should return NO", ^{
                    expect(is_valid).to.beFalsy();
                });
                
                it(@"should add correct error state to validationStates", ^{
                    expect(validator.validationStates).to.contain(kPMValidationStatusMinimumLengthError);
                });
            });
            
            describe(@", and valid text", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"cool"];
                });
                
                it(@"should return YES", ^{
                    expect(is_valid).to.beTruthy();
                });
            });
            
        });
        
        
        describe(@"when maximumCharacters is specified", ^{
            beforeAll(^{
                validator = [PMValidationLengthType validator];
                [validator setMaximumCharacters:4];
                
                expect(validator.maximumCharacters).to.equal(4);
                
            });
            
            describe(@", and invalid text", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"long-winded"];
                });
                
                
                it(@"should return NO", ^{
                    expect(is_valid).to.beFalsy();
                });
                
                it(@"should add correct error state to validationStates", ^{
                    expect(validator.validationStates).to.contain(kPMValidationStatusMaximumLengthError);
                });
            });
            
            describe(@", and valid text", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"cool"];
                });
                
                it(@"should return YES", ^{
                    expect(is_valid).to.beTruthy();
                });
            });
            
        });
        
        
        
        describe(@"when both minimumCharacters and maximumCharacters is specified", ^{
            beforeAll(^{
                validator = [PMValidationLengthType validator];
                [validator setMinimumCharacters:2];
                [validator setMaximumCharacters:4];
                
            });
            
            describe(@", and string is too short", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"a"];
                });
                
                
                it(@"should return NO", ^{
                    expect(is_valid).to.beFalsy();
                });
                
                it(@"should add correct error state to validationStates", ^{
                    expect(validator.validationStates).to.contain(kPMValidationStatusMinimumLengthError);
                });
            });
            
            describe(@", and string is too long", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"too long buddy"];
                });
                
                
                it(@"should return NO", ^{
                    expect(is_valid).to.beFalsy();
                });
                
                it(@"should add correct error state to validationStates", ^{
                    expect(validator.validationStates).to.contain(kPMValidationStatusMaximumLengthError);
                });
            });
            
            describe(@", and string is just right", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"cool"];
                });
                
                it(@"should return YES", ^{
                    expect(is_valid).to.beTruthy();
                });
            });
            
        });
        
        
        describe(@"when maximumCharacters is same length as minimumCharacters", ^{
            beforeAll(^{
                validator = [PMValidationLengthType validator];
                [validator setMinimumCharacters:4];
                [validator setMaximumCharacters:4];
                
            });
            
            describe(@", and text is same length as min and max", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"four"];
                });
                
                
                it(@"should return YES", ^{
                    expect(is_valid).to.beTruthy();
                });
            });
            
        });
        
        
        describe(@"when maximumCharacters is less than minimumCharacters", ^{
            beforeAll(^{
                validator = [PMValidationLengthType validator];
                [validator setMinimumCharacters:4];
                [validator setMaximumCharacters:2];
                
            });
            
            describe(@", and text is less than min but greater than max", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"yes"];
                });
                
                
                it(@"should return NO", ^{
                    expect(is_valid).to.beFalsy();
                });
            });
            
            describe(@", and text is equal to min and greater than max", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"cool"];
                });
                
                
                it(@"should return YES", ^{
                    expect(is_valid).to.beTruthy();
                });
            });
            
        });
        
        
    });
    
});

SpecEnd