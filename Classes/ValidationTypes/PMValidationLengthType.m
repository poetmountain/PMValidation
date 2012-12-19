//
//  PMValidationLengthType.m
//  
//
//  Created by Brett Walker on 6/9/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationLengthType.h"

@implementation PMValidationLengthType

NSString *const kPMValidationStatusMinimumLengthError = @"PMValidationStatusMinimumLengthError";
NSString *const kPMValidationStatusMaximumLengthError = @"PMValidationStatusMaximumLengthError";
NSInteger const kPMValidationIgnoreLengthConstraint = -1;

@synthesize minimumCharacters;
@synthesize maximumCharacters;

-(id)init {
    
    self = [super init];
    if (self) {
        self.minimumCharacters = kPMValidationIgnoreLengthConstraint;
        self.maximumCharacters = kPMValidationIgnoreLengthConstraint;
    }
    
    return self;
}


// returns a new, autoreleased instance of PMValidationLengthType
+ (id) validator {
    
    PMValidationLengthType *val = [[[PMValidationLengthType alloc] init] autorelease];
    
    val.minimumCharacters = kPMValidationIgnoreLengthConstraint;
    val.maximumCharacters = kPMValidationIgnoreLengthConstraint;
    
    return val;
    
}


-(BOOL) isTextValid:(NSString *)text {
        
    BOOL min_valid = YES;
    BOOL max_valid = YES;
    if (self.minimumCharacters == kPMValidationIgnoreLengthConstraint) {
        min_valid = YES;
    } else if (self.minimumCharacters >= 0) {
        (text.length >= self.minimumCharacters) ? (min_valid = YES) : (min_valid = NO);
    }
    
    if (self.maximumCharacters == kPMValidationIgnoreLengthConstraint) {
        max_valid = YES;
    } else if (self.maximumCharacters >= 0) {
        (text.length <= self.maximumCharacters) ? (max_valid = YES) : (max_valid = NO);
    }
    
    if (min_valid == YES && max_valid == YES) {
        self.isValid = YES;
    } else {
        self.isValid = NO;
    }
    
    // update states
    [self.validationStates removeAllObjects];
    if (self.isValid) {
        [self.validationStates addObject:kPMValidationStatusValid];
    } else {
        if (min_valid == NO) {
            [self.validationStates addObject:kPMValidationStatusMinimumLengthError];
        }
        if (max_valid == NO) {
            [self.validationStates addObject:kPMValidationStatusMaximumLengthError];
        }
        
    }
    
    return self.isValid;
}


+ (NSString *)type {
    
    return @"PMValidationTypeLength";
}


@end
