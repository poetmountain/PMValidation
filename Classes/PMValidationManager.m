//
//  PMValidationManager.m
//  
//
//  Created by Brett Walker on 6/7/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationManager.h"
#import "PMValidationUnit.h"

@interface PMValidationManager()

/*
 This dictionary contains all registered validation units.
 The key is a text object being validated, and the value is a PMValidationUnit instance validating it.
 */
@property (nonatomic, strong) NSMutableDictionary *validationUnits;

// incremental counter, used to assure unique identifier generation
@property (nonatomic, assign) NSUInteger identifierCounter;

// Internal method to determine validation status of all registered PMValidationUnit instances.
- (BOOL)areAllValid;

// called when a PMValidationUnit instance is updated
- (void)unitUpdateNotificationHandler:(NSNotification *)note;

// generates a unique identifier, used when no identifier is passed in
- (NSString *)generateIdentifier;

@end


@implementation PMValidationManager

NSString *const PMValidationStatusNotification = @"PMValidationStatusNotification";


#pragma mark - Lifecycle methods

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _validationUnits = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


// returns a new instance of PMValidationManager 
+ (instancetype) validationManager {
    
    PMValidationManager *vm = [[PMValidationManager alloc] init];
    
    return vm;
    
}



- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
        
}



#pragma mark - Object registration methods


- (PMValidationUnit *)registerTextField:(UITextField *)textField forValidationTypes:(NSOrderedSet *)validationTypes identifier:(NSString *)identifier {
        
    PMValidationUnit *unit = [self registerObject:textField forValidationTypes:validationTypes objectNotificationType:UITextFieldTextDidChangeNotification identifier:identifier];
    
    return unit;

}

- (PMValidationUnit *)registerTextView:(UITextView *)textView forValidationTypes:(NSOrderedSet *)validationTypes identifier:(NSString *)identifier {
    
    PMValidationUnit *unit = [self registerObject:textView forValidationTypes:validationTypes objectNotificationType:UITextViewTextDidChangeNotification identifier:identifier];
    
    return unit;
    
}


- (PMValidationUnit *)registerObject:(id)object forValidationTypes:(NSOrderedSet *)validationTypes objectNotificationType:(NSString *)notificationType identifier:(NSString *)identifier {
    
    NSString *unit_identifier = identifier;
    if (!unit_identifier) {
        // if no identifier passed in and no identifier found on the unit, create one
        unit_identifier = [self generateIdentifier];
    }
    
    // create validation unit with passed-in types and save it
    PMValidationUnit *unit = [[PMValidationUnit alloc] initWithValidationTypes:validationTypes identifier:unit_identifier];
    [self.validationUnits setObject:unit forKey:unit_identifier];
    
    // add listener for object which will pass on text changes to validation unit
    if (notificationType) {
        [[NSNotificationCenter defaultCenter] addObserver:unit
                                                 selector:@selector(textDidChangeNotification:)                                                 
                                                     name:notificationType
                                                   object:object];
    }
        
    
    // listen for validation updates from unit
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unitUpdateNotificationHandler:) name:PMValidationUnitUpdateNotification object:unit];

    
    return unit;
}


- (NSString *)addUnit:(PMValidationUnit *)unit {
    
    NSString *identifier = [self addUnit:unit identifier:nil];
    
    return identifier;
}


- (NSString *)addUnit:(PMValidationUnit *)unit identifier:(NSString *)identifier {
    
    if (!unit) {
        return nil;
    }
    
    // if an identifier is passed in, that is used instead of the unit's identifier property
    NSString *unit_identifier = (identifier) ? identifier : unit.identifier;
    
    if (!unit_identifier) {
        // if no identifier passed in and no identifier found on the unit, create one
        unit_identifier = [self generateIdentifier];
    }
    
    [self.validationUnits setObject:unit forKey:unit_identifier];
    
    // listen for validation updates from unit
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unitUpdateNotificationHandler:) name:PMValidationUnitUpdateNotification object:unit];
    
    return unit_identifier;

}


- (void)removeUnitForIdentifier:(NSString *)identifier {
    
    // remove validation update listener for this unit
    PMValidationUnit *unit = [self unitForIdentifier:identifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PMValidationUnitUpdateNotification object:unit];
    
    [self.validationUnits removeObjectForKey:identifier];
    
}


- (NSString *)generateIdentifier {
    
    NSString *identifier = [[NSNumber numberWithUnsignedInteger:self.identifierCounter++] stringValue];
    
    return identifier;
}


#pragma mark - Notification methods

- (void)unitUpdateNotificationHandler:(NSNotification *)note {
    

    // update overall validation status
    self.isValid = [self areAllValid];
    
    // collect all unit errors
    NSMutableDictionary *total_errors = [NSMutableDictionary dictionary];
    [self.validationUnits enumerateKeysAndObjectsUsingBlock:^(NSString *key, PMValidationUnit *unit, BOOL *stop) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:unit.isValid], @"isValid",
                              unit.errors, @"errors",
                              nil];
        [total_errors setObject:dict forKey:unit.identifier];
        
    }];
    
    // post status update notification
    NSNumber *is_valid_number = [NSNumber numberWithBool:self.isValid];
    NSDictionary *status_dict = @{@"status":is_valid_number, @"units":[total_errors copy]};
    [[NSNotificationCenter defaultCenter] postNotificationName:PMValidationStatusNotification object:self userInfo:status_dict];
    
    
}



#pragma mark - Utility methods

- (PMValidationUnit *)unitForIdentifier:(NSString *)identifier {
    
    PMValidationUnit *unit = [self.validationUnits objectForKey:identifier];
    
    return unit;
    
}



- (BOOL)areAllValid {
    
    __block BOOL are_valid = YES;
    
    [self.validationUnits enumerateKeysAndObjectsUsingBlock:^(NSString *key, PMValidationUnit *unit, BOOL *stop) {
        if (unit.enabled && !unit.isValid) {
            are_valid = NO;
            *stop = YES;
        }
    }];
    
    
    return are_valid;
    
}


@end
