//
//  PMValidationManagerSpec.m
//  PMValidationTests
//
//  Created by Brett Walker on 3/27/14.
//
//

#import <XCTest/XCTest.h>
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "PMValidationManager.h"
#import "PMValidationUnit.h"
#import "PMValidationType.h"
#import "PMValidationLengthType.h"

@interface PMValidationUnit ()

- (void)validationComplete;

@end

SpecBegin(PMValidationManager)

describe(@"PMValidationManager", ^{
    __block PMValidationManager *manager;

    
    describe(@"+validationManager", ^{
        beforeAll(^{
            manager = [PMValidationManager validationManager];
        });
        
        it(@"should return an instance of PMValidationManager", ^{
            expect(manager).to.beInstanceOf([PMValidationManager class]);
        });
    });
    
    
    describe(@"-registerTextField: forValidationTypes: identifier:", ^{
        __block NSString *type_identifier;
        __block PMValidationType *validation_type;
        __block UITextField *text_field;
        __block NSOrderedSet *set;
        __block PMValidationUnit *unit;
    

        beforeAll(^{
            manager = [PMValidationManager validationManager];
            validation_type = [PMValidationType validator];
            type_identifier = @"testType";
            validation_type.identifier = type_identifier;
            text_field = [[UITextField alloc] init];
            set = [NSOrderedSet orderedSetWithObjects:validation_type, nil];
        });
        
        it(@", should return a PMValidationUnit with our validator", ^{
            unit = [manager registerTextField:text_field forValidationTypes:set identifier:@"textField"];
            expect([unit validationTypeForIdentifier:type_identifier]).to.beIdenticalTo(validation_type);
        });
    
    });
    
    
    describe(@"-registerTextView: forValidationTypes: identifier:", ^{
        __block NSString *type_identifier;
        __block PMValidationType *validation_type;
        __block UITextView *text_view;
        __block NSOrderedSet *set;
        
        
        beforeAll(^{
            manager = [PMValidationManager validationManager];
            validation_type = [PMValidationType validator];
            type_identifier = @"testType";
            validation_type.identifier = type_identifier;
            text_view = [[UITextView alloc] init];
            set = [NSOrderedSet orderedSetWithObjects:validation_type, nil];
        });
        
        it(@", should return a PMValidationUnit with our validator", ^{
            PMValidationUnit *unit = [manager registerTextView:text_view forValidationTypes:set identifier:@"textView"];
            expect([unit validationTypeForIdentifier:type_identifier]).to.beIdenticalTo(validation_type);
        });
        
    });
    
    
    describe(@"-unitForIdentifier:", ^{
        __block NSString *unit_identifier;
        __block PMValidationUnit *unit;
        
        beforeAll(^{
            manager = [PMValidationManager validationManager];
            PMValidationType *validation_type = [PMValidationType validator];
            validation_type.identifier = @"testType";
            UITextField *text_field = [[UITextField alloc] init];
            NSOrderedSet *set = [NSOrderedSet orderedSetWithObjects:validation_type, nil];
            unit = [manager registerTextField:text_field forValidationTypes:set identifier:@"textField"];
            unit_identifier = unit.identifier;
        });
        
        
        it(@", should return a unit with the right identifier", ^{
            expect([manager unitForIdentifier:unit_identifier]).to.beIdenticalTo(unit);
        });
        
        it(@", should return nil for the wrong identifier", ^{
            expect([manager unitForIdentifier:@"nope"]).to.beNil();
        });
        
    });
    
    
    describe(@"validation when a PMValidationUnit notifies", ^{
        __block NSString *unit_identifier;
        __block PMValidationUnit *unit;
        __block UITextField *text_field;
        
        beforeAll(^{
            manager = [PMValidationManager validationManager];
            PMValidationLengthType *validation_type = [PMValidationLengthType validator];
            validation_type.minimumCharacters = 4;
            validation_type.identifier = @"testType";
            text_field = [[UITextField alloc] init];
            NSOrderedSet *set = [NSOrderedSet orderedSetWithObjects:validation_type, nil];
            unit = [manager registerTextField:text_field forValidationTypes:set identifier:@"textField"];
            unit_identifier = unit.identifier;
        });
        
        it(@"should send notification", ^{
           
            __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:PMValidationStatusNotification object:manager queue:nil usingBlock:^(NSNotification *note) {
                
                expect(note.object).to.beIdenticalTo(manager);
                expect(note.userInfo[@"status"]).to.beTruthy();
                expect(manager.isValid).to.beTruthy();

                
                [[NSNotificationCenter defaultCenter] removeObserver:observer];
                
            }];
            
            expect(^{
                NSNotification *note = [[NSNotification alloc] initWithName:UITextFieldTextDidChangeNotification object:text_field userInfo:nil];
                text_field.text = @"cool";
                [unit textDidChangeNotification:note];
            }).will.notify(PMValidationStatusNotification);
            
        });
        
        
    });
    
    
});

SpecEnd