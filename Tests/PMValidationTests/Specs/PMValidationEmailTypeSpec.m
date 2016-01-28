//
//  PMValidationEmailTypeSpec.m
//  PMValidationTests
//
//  Created by Brett Walker on 3/26/14.
//  Copyright (c) 2012-2016 Poet & Mountain, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMValidationEmailType.h"

SpecBegin(PMValidationEmailType)

describe(@"PMValidationEmailType", ^{
    __block PMValidationEmailType *validator;
    __block BOOL is_valid;
    
    describe(@"+validatator", ^{
        
        beforeAll(^{
            validator = [PMValidationEmailType validator];
        });
        
        it(@"should return an instance of PMValidationEmailType", ^{
            expect(validator).to.beInstanceOf([PMValidationEmailType class]);
        });
    });
    
    describe(@"-isTextValid", ^{
        
        beforeAll(^{
            validator = [PMValidationEmailType validator];
        });
        
        
        
        describe(@", basic address is valid", ^{
            
            before(^{
                is_valid = [validator isTextValid:@"some@address.com"];
            });
            
            
            it(@"should return YES", ^{
                expect(is_valid).to.beTruthy();
            });
            
        });
        
        
        
        describe(@", address has no at sign", ^{
            
            before(^{
                is_valid = [validator isTextValid:@"some.domain.com"];
            });
            
            
            it(@"should return NO", ^{
                expect(is_valid).to.beFalsy();
            });
            
            it(@"should add correct error state to validationStates", ^{
                expect(validator.validationStates).to.contain(kPMValidationStatusInvalid);
            });
            
        });
        
        
        describe(@", address has no sender", ^{
            
            before(^{
                is_valid = [validator isTextValid:@"@domain.com"];
            });
            
            
            it(@"should return NO", ^{
                expect(is_valid).to.beFalsy();
            });
            
        });
    
        
        describe(@", address has no domain name", ^{
            
            before(^{
                is_valid = [validator isTextValid:@"some@.com"];
            });
            
            
            it(@"should return NO", ^{
                expect(is_valid).to.beFalsy();
            });
            
        });
        
        
        describe(@", address has invalid TLD", ^{
            
            before(^{
                is_valid = [validator isTextValid:@"some@domain.c"];
            });
            
            
            it(@"should return NO", ^{
                expect(is_valid).to.beFalsy();
            });
            
        });
        
        
        describe(@", address has invalid characters", ^{
            
            describe(@"– backslash char", ^{
                before(^{
                    is_valid = [validator isTextValid:@"some\\@domain.com"];
                });
                
                
                it(@"should return NO", ^{
                    expect(is_valid).to.beFalsy();
                });

            });
            
            
            
            describe(@"– Unicode emoji char", ^{
                before(^{
                    is_valid = [validator isTextValid:@"craft🍺@domain.com"];
                });
                
                
                it(@"should return NO", ^{
                    expect(is_valid).to.beFalsy();
                });
                
            });
            
            
            describe(@", non-standard chars in domain portion", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"some+info@address~!#$%&'*+-/=?^_`{|}.com"];
                });
                
                
                it(@"should return NO", ^{
                    expect(is_valid).to.beFalsy();
                });
                
            });
            
            describe(@", non-standard chars in TLD portion", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"some+info@address.com~!#$%&'*+-/=?^_`{|}"];
                });
                
                
                it(@"should return NO", ^{
                    expect(is_valid).to.beFalsy();
                });
                
            });
            
            
            describe(@", international characters", ^{
                
                before(^{
                    is_valid = [validator isTextValid:@"some@hüskerdu.com"];
                });
                
                
                it(@"should return NO", ^{
                    expect(is_valid).to.beFalsy();
                });
                
            });

            
        });
        
        

        describe(@", address has non-standard chars in sender portion which are valid under RFC 5322", ^{
            
            before(^{
                is_valid = [validator isTextValid:@"some+info~!#$%&'*+-/=?^_`{|}@address.com"];
            });
            
            
            it(@"should return YES", ^{
                expect(is_valid).to.beTruthy();
            });
            
        });
        
        

        
    });
    
});


SpecEnd