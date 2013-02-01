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
@property (nonatomic, retain) NSMutableDictionary *validationUnits;


// Internal method to determine validation status of all registered PMValidationUnit instances.
- (BOOL) areAllValid;


@end


@implementation PMValidationManager

NSString *const PMValidationStatusNotification = @"PMValidationStatusNotification";


@synthesize validationUnits;
@synthesize isValid;

#pragma mark - Lifecycle methods

-(id)init {
    
    self = [super init];
    if (self) {
        self.validationUnits = [[[NSMutableDictionary alloc] init] autorelease];
    }
    
    return self;
}


// returns a new, autoreleased instance of PMValidationManager 
+ (PMValidationManager *) validationManager {
    
    PMValidationManager *vm = [[[PMValidationManager alloc] init] autorelease];
    
    return vm;
    
}



-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [validationUnits release];
    
    [super dealloc];
}






#pragma mark - Object registration methods


-(PMValidationUnit *)registerTextField:(UITextField *)textField forValidationTypes:(NSSet *)validationTypes identifier:(id)identifier {
        
    PMValidationUnit *unit = [self registerObject:textField forValidationTypes:validationTypes objectNotificationType:UITextFieldTextDidChangeNotification identifier:identifier];
    
    return unit;

}

-(PMValidationUnit *)registerTextView:(UITextView *)textView forValidationTypes:(NSSet *)validationTypes identifier:(id)identifier {
    
    PMValidationUnit *unit = [self registerObject:textView forValidationTypes:validationTypes objectNotificationType:UITextViewTextDidChangeNotification identifier:identifier];
    
    return unit;
    
}


-(PMValidationUnit *)registerObject:(id)object forValidationTypes:(NSSet *)validationTypes objectNotificationType:(NSString *)notificationType identifier:(NSString *)identifier {
    
    NSString *unit_identifier = identifier;
    if (unit_identifier == nil) {
        // if no identifier passed in, create one
        unit_identifier = [[NSNumber numberWithInteger:[self.validationUnits count]+1] stringValue];
    }
    
    // create validation unit with passed-in types and save it
    PMValidationUnit *unit = [[[PMValidationUnit alloc] initWithValidationTypes:validationTypes identifier:unit_identifier] autorelease];
    [self.validationUnits setObject:unit forKey:unit_identifier];
    
    // add listener for object which will pass on text changes to validation unit
    if (notificationType) {
        [[NSNotificationCenter defaultCenter] addObserver:unit
                                                 selector:@selector(textDidChangeNotification:)                                                 
                                                     name:notificationType
                                                   object:object];
    }
        
    
    // listen for validation updates from unit
    __unsafe_unretained PMValidationManager *weak_self = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:PMValidationUnitUpdateNotification object:unit queue:nil usingBlock:
        ^(NSNotification *notification){
            
            if (weak_self) {
                // update overall validation status
                weak_self.isValid = [weak_self areAllValid];
                            
                // collect all unit errors
                NSMutableDictionary *total_errors = [NSMutableDictionary dictionary];
                [weak_self.validationUnits enumerateKeysAndObjectsUsingBlock:^(NSString *key, PMValidationUnit *unit, BOOL *stop) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithBool:unit.isValid], @"isValid",
                                          unit.errors, @"errors",
                                          nil];
                    [total_errors setObject:dict forKey:unit.identifier];
                    
                }];
                
                // post status update notification
                NSNumber *is_valid_number = [NSNumber numberWithBool:weak_self.isValid];
                NSDictionary *status_dict = @{@"status":is_valid_number, @"units":total_errors};
                [[NSNotificationCenter defaultCenter] postNotificationName:PMValidationStatusNotification object:weak_self userInfo:status_dict];
            }
        }
     ];

    
    return unit;
}





#pragma mark - Utility methods

- (PMValidationUnit *)unitForIdentifier:(NSString *)identifier {
    
    PMValidationUnit *unit = [self.validationUnits objectForKey:identifier];
    
    return unit;
    
}



-(BOOL) areAllValid {
    
    __block BOOL are_valid = YES;
    
    [self.validationUnits enumerateKeysAndObjectsUsingBlock:^(NSString *key, PMValidationUnit *unit, BOOL *stop) {
        if (!unit.isValid) {
            are_valid = NO;
            *stop = YES;
        }
    }];
    
    
    return are_valid;
    
}


@end
