//
//  PMValidationUnit.m
//
//  Created by Brett Walker on 6/7/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
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
@property (nonatomic, assign) dispatch_queue_t validationQueue;

/*
 The previous value to compare against
 */
@property (nonatomic, copy) NSString *lastTextValue;


// called when all PMValidationType objects have updated validation
- (void) validationComplete;

@end


@implementation PMValidationUnit

NSString *const PMValidationUnitUpdateNotification = @"PMValidationUnitUpdateNotification";


#pragma mark - Lifecycle methods

- (id)init {
    
    self = [super init];
    
    if (self) {
        _registeredValidationTypes = [NSMutableOrderedSet orderedSet];
        _errors = [NSMutableDictionary dictionary];
        
        // create validation dispatch queue
        dispatch_queue_t q = dispatch_queue_create("com.poetmountain.PMValidationUnitQueue", NULL);
        dispatch_retain(q);
        _validationQueue = q;
    }
    
    return self;
}


-(id)initWithValidationTypes:(NSOrderedSet *)validationTypes identifier:(NSString *)targetIdentifier {
    
    
    self = [super init];
    if (self) {
        self.registeredValidationTypes = [NSMutableOrderedSet orderedSetWithOrderedSet:validationTypes];
        self.errors = [NSMutableDictionary dictionary];
        self.identifier = targetIdentifier;
        // register for notifications for validation types that send updates
        for (PMValidationType *type in self.registeredValidationTypes) {
            if (type.sendsUpdates) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validationUnitStatusUpdatedNotification:) name:PMValidationUpdateNotification object:type];
            }
        }
        
        // create validation dispatch queue
        dispatch_queue_t q = dispatch_queue_create("com.poetmountain.PMValidationUnitQueue", NULL);
        dispatch_retain(q);
        self.validationQueue = q;

    }
    
    return self;
}


// returns a new instance of PMValidationUnit
+ (PMValidationUnit *) validationUnit {
    
    PMValidationUnit *vu = [[PMValidationUnit alloc] init];
    
    return vu;
    
}




-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    dispatch_release(self.validationQueue);

}



#pragma mark - Validation methods



- (void)registerValidationType:(PMValidationType *)validationType {
    
    [self.registeredValidationTypes addObject:validationType];
    
    
}


- (void)clearValidationTypes {
    [self.registeredValidationTypes removeAllObjects];

}


- (void)validationComplete {
    
    // first remove any old errors
    [self.errors removeAllObjects];
    
    NSDictionary *total_errors = nil;
    
    if (!self.isValid) {
        for (PMValidationType *validation_type in self.registeredValidationTypes) {
            if (!validation_type.isValid) {
                [self.errors setObject:validation_type.validationStates forKey:[[validation_type class] type]];
            }
        }
        total_errors = [NSDictionary dictionaryWithObject:self.errors forKey:@"errors"];
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PMValidationUnitUpdateNotification object:self userInfo:total_errors];
   
}


                                                 


#pragma mark - Text

- (void)validateText:(NSString *)text {

    __weak PMValidationUnit *weak_self = self;
    
    dispatch_async(self.validationQueue, ^{
        
        if (weak_self) {
            __strong PMValidationUnit *strong_self = weak_self;
            if (strong_self) {
                __block NSInteger num_valid = 0;
                [strong_self.registeredValidationTypes enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PMValidationType *type,NSUInteger idx, BOOL *stop) {
                    
                    BOOL is_valid = [type isTextValid:text];
                    num_valid += [[NSNumber numberWithBool:is_valid] integerValue];

                }];
                
                NSInteger type_count = [strong_self.registeredValidationTypes count];
                (num_valid == type_count) ? (strong_self.isValid = YES) : (strong_self.isValid = NO);

                strong_self.lastTextValue = text;
            
                // send notification (on main queue, because there be UI work)
                __weak PMValidationUnit *weak_weak_self = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weak_weak_self) {
                        __strong PMValidationUnit *strong_strong_self = weak_weak_self;
                        if (strong_strong_self) {
                            [strong_strong_self validationComplete];
                        }
                    }
                });
            }
        }
        
    });
    

    
}


#pragma mark - Utility methods


- (PMValidationType *) validationTypeForIdentifier:(NSString *)theIdentifier {
    
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

- (void) textDidChangeNotification:(NSNotification *)notification {
    
    if (notification.name == UITextFieldTextDidChangeNotification) {
        UITextField *text_field = (UITextField *)notification.object;
        [self validateText:text_field.text];
    } else if (notification.name == UITextViewTextDidChangeNotification) {
        UITextView *text_view = (UITextView *)notification.object;
        [self validateText:text_view.text];
    }

    
}


-(void)validationUnitStatusUpdatedNotification:(NSNotification *)notification {
    
    BOOL is_valid = (BOOL)[(NSNumber *)[notification.userInfo objectForKey:@"status"] boolValue];
    
    if (is_valid) {
        [self validateText:self.lastTextValue];
    } else {
        self.isValid = NO;
        [self validationComplete];

    }
    
    
}


@end
