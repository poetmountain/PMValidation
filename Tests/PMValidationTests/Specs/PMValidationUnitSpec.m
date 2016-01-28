//
//  PMValidationUnitTests.m
//  PMValidationTests
//
//  Created by Brett Walker on 3/25/14.
//  Copyright (c) 2012-2016 Poet & Mountain, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMValidationUnit.h"
#import "PMValidationType.h"
#import "PMValidationLengthType.h"

SpecBegin(PMValidationUnitTests)

describe(@"PMValidationUnit", ^{
    __block PMValidationUnit *unit;
    
    
    describe(@"+validationUnit", ^{
        beforeAll(^{
            unit = [PMValidationUnit validationUnit];
        });
        
        it(@"should return an instance of PMValidationUnit", ^{
            expect(unit).to.beInstanceOf([PMValidationUnit class]);
        });
    });
   

    
    describe(@"-initWithValidationTypes: identifier:", ^{
        
        beforeAll(^{
            PMValidationType *type = [PMValidationType validator];
            NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:@[type]];
            unit = [[PMValidationUnit alloc] initWithValidationTypes:set identifier:@"testUnit"];
        });
        
        
        it(@"should return an instance of PMValidationUnit", ^{
            expect(unit).to.beInstanceOf([PMValidationUnit class]);
        });
        

        
    });
    
    describe(@"-registerValidationType", ^{
        
        __block NSString *type_identifier;

        beforeAll(^{
            PMValidationType *type = [PMValidationType validator];
            type_identifier = @"testType";
            type.identifier = type_identifier;
            unit = [PMValidationUnit validationUnit];
            
            [unit registerValidationType:type];
        });
        
        it(@"should populate registeredValidationTypes", ^{
            PMValidationType *type = [unit validationTypeForIdentifier:type_identifier];
            expect(type).to.beInstanceOf([PMValidationType class]);
        });
    });
    
    
    describe(@"-clearValidationTypes", ^{
        
        __block NSString *type_identifier;
        
        beforeAll(^{
            PMValidationType *type = [PMValidationType validator];
            NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:@[type]];
            type_identifier = @"testType";
            type.identifier = type_identifier;
            unit = [[PMValidationUnit alloc] initWithValidationTypes:set identifier:@"testUnit"];
            
            [unit clearValidationTypes];
        });
        
        it(@"should clear the registered types", ^{
            PMValidationType *type = [unit validationTypeForIdentifier:type_identifier];
            expect(type).to.beNil();
        });
    });
    
    
    describe(@"text validation", ^{
        
        beforeAll(^{
            PMValidationLengthType *validation_type = [PMValidationLengthType validator];
            validation_type.minimumCharacters = 4;
            validation_type.identifier = @"testType";
            NSOrderedSet *set = [NSOrderedSet orderedSetWithObjects:validation_type, nil];
            unit = [[PMValidationUnit alloc] initWithValidationTypes:set identifier:@"testUnit"];
        });
        
        describe(@"unit is enabled, ", ^{
            it(@"should send a PMValidationUnitUpdateNotification notification", ^{
                
                __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:PMValidationUnitUpdateNotification object:unit queue:nil usingBlock:^(NSNotification *note) {
                    
                    expect(note.object).to.beIdenticalTo(unit);
                    expect(note.userInfo[@"errors"]).to.beNil;
                    expect(unit.isValid).to.beTruthy();
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:observer];
                    
                }];
                
                expect(^{ [unit validateText:@"testing"]; }).will.notify(PMValidationUnitUpdateNotification);
                
            });
        });
        
        describe(@"unit is disabled, ", ^{
            before(^{
                unit.enabled = NO;
            });
            it(@"should not validate text", ^{
                expect(^{ [unit validateText:@"testing"]; }).willNot.notify(PMValidationUnitUpdateNotification);
            });
        });
        
    });

    
    
});



SpecEnd


