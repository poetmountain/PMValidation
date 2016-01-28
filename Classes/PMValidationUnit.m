//
//  PMValidationUnit.m
//
//  Created by Brett Walker on 6/7/12.
//  Copyright (c) 2012-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationUnit.h"
#import "PMValidationManager.h"
#import "PMValidationType.h"

@interface PMValidationUnit ()

/*
 The PMValidationType subclasses that are registered with this instance
 */
@property (nonatomic, strong) NSMutableOrderedSet *registeredValidationTypes;

/*
 This dispatch queue is used to send events to the `PMValidationType` subclass objects
 */
@property (nonatomic, strong) dispatch_queue_t validationQueue;

/*
 The previous value to compare against
 */
@property (nonatomic, copy) NSString *lastTextValue;


// called when all PMValidationType objects have updated validation
- (void)validationComplete;

@end


@implementation PMValidationUnit

NSString *const PMValidationUnitUpdateNotification = @"PMValidationUnitUpdateNotification";


#pragma mark - Lifecycle methods

- (instancetype)init {
    
    return [self initWithValidationTypes:[NSMutableOrderedSet orderedSet] identifier:@"empty"];
}


- (instancetype)initWithValidationTypes:(NSOrderedSet *)validationTypes identifier:(NSString *)targetIdentifier {
    
    self = [super init];
    if (self) {
        _registeredValidationTypes = [NSMutableOrderedSet orderedSetWithOrderedSet:validationTypes];
        _errors = [NSDictionary dictionary];
        _identifier = targetIdentifier;
        
        // register for notifications for validation types that send updates
        for (PMValidationType *type in self.registeredValidationTypes) {
            if (type.sendsUpdates) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validationUnitStatusUpdatedNotification:) name:PMValidationUpdateNotification object:type];
            }
        }
        
        // create validation dispatch queue
        dispatch_queue_t q = dispatch_queue_create("com.poetmountain.PMValidationUnitQueue", NULL);
        _validationQueue = q;
        
        _enabled = YES;

    }
    
    return self;
}


// returns a new instance of PMValidationUnit
+ (instancetype)validationUnit {
    
    PMValidationUnit *vu = [[PMValidationUnit alloc] init];
    
    return vu;
    
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark - getter/setter methods

- (void)setEnabled:(BOOL)enabled {
    
    _enabled = enabled;
    
}


#pragma mark - Validation methods


- (void)registerValidationType:(PMValidationType *)validationType {
    
    [self.registeredValidationTypes addObject:validationType];
    
    
}


- (void)clearValidationTypes {
    [self.registeredValidationTypes removeAllObjects];

}


- (void)validationComplete {

    
    NSDictionary *total_errors = nil;
    NSMutableDictionary *validation_errors = [NSMutableDictionary dictionary];
    
    if (!self.isValid) {
        for (PMValidationType *validation_type in self.registeredValidationTypes) {
            if (!validation_type.isValid) {
                [validation_errors setObject:validation_type.validationStates forKey:[[validation_type class] type]];
            }
        }
        self.errors = [validation_errors copy];
        total_errors = [NSDictionary dictionaryWithObject:self.errors forKey:@"errors"];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PMValidationUnitUpdateNotification object:self userInfo:total_errors];
   
}


                                                 


#pragma mark - Text

- (void)validateText:(NSString *)text {

    if (self.enabled) {
            
        __weak PMValidationUnit *weak_self = self;
        
        dispatch_async(self.validationQueue, ^{
            
            if (weak_self) {
                __strong PMValidationUnit *strong_self = weak_self;
                if (strong_self) {
                    NSUInteger num_valid = 0;
                    for (PMValidationType *type in strong_self.registeredValidationTypes) {
                        BOOL is_valid = [type isTextValid:text];
                        num_valid += [[NSNumber numberWithBool:is_valid] unsignedIntegerValue];
                    }
                    
                    NSUInteger type_count = [strong_self.registeredValidationTypes count];
                    (num_valid == type_count) ? (strong_self.isValid = YES) : (strong_self.isValid = NO);

                    strong_self.lastTextValue = text;
                
                    // send notification (on main queue, because there be UI work)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strong_self validationComplete];
                    });
                }
            }
            
        });
    
    }
    
}


#pragma mark - Utility methods


- (PMValidationType *)validationTypeForIdentifier:(NSString *)theIdentifier {
    
    PMValidationType *validation_type = nil;
    
    for (PMValidationType *this_type in self.registeredValidationTypes) {
        if ([this_type.identifier isEqualToString:theIdentifier]) {
            validation_type = this_type;
            break;
        }
    }
    
    return validation_type;
    
}




#pragma mark - Notifications

- (void)textDidChangeNotification:(NSNotification *)notification {
    
    if (notification.name == UITextFieldTextDidChangeNotification) {
        UITextField *text_field = (UITextField *)notification.object;
        [self validateText:text_field.text];
    } else if (notification.name == UITextViewTextDidChangeNotification) {
        UITextView *text_view = (UITextView *)notification.object;
        [self validateText:text_view.text];
    }

    
}


- (void)validationUnitStatusUpdatedNotification:(NSNotification *)notification {
    
    if (self.enabled) {
        
        BOOL is_valid = (BOOL)[(NSNumber *)[notification.userInfo objectForKey:@"status"] boolValue];
        
        if (is_valid) {
            [self validateText:self.lastTextValue];
        } else {
            self.isValid = NO;
            [self validationComplete];

        }
    
    }
    
}


@end
