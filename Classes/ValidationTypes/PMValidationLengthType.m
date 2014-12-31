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


- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.minimumCharacters = kPMValidationIgnoreLengthConstraint;
        self.maximumCharacters = kPMValidationIgnoreLengthConstraint;
    }
    
    return self;
}


// returns a new instance of PMValidationLengthType
+ (instancetype) validator {
    
    PMValidationLengthType *val = [[PMValidationLengthType alloc] init];
    
    val.minimumCharacters = kPMValidationIgnoreLengthConstraint;
    val.maximumCharacters = kPMValidationIgnoreLengthConstraint;
    
    return val;
    
}


- (BOOL)isTextValid:(NSString *)text {
        
    BOOL min_valid = YES;
    BOOL max_valid = YES;
    if (self.minimumCharacters == kPMValidationIgnoreLengthConstraint) {
        min_valid = YES;
    } else if (self.minimumCharacters >= 0) {
        (text.length >= self.minimumCharacters) ? (min_valid = YES) : (min_valid = NO);
    }
    
    if (self.maximumCharacters == kPMValidationIgnoreLengthConstraint) {
        max_valid = YES;
        
    // if max is less than min, the max constraint is ignored
    } else if (self.maximumCharacters >= 0 && self.maximumCharacters >= self.minimumCharacters) {
        (text.length <= self.maximumCharacters) ? (max_valid = YES) : (max_valid = NO);
    }
    
    if (min_valid && max_valid) {
        self.isValid = YES;
    } else {
        self.isValid = NO;
    }
    
    // update states
    [self.validationStates removeAllObjects];
    if (self.isValid) {
        [self.validationStates addObject:kPMValidationStatusValid];
    } else {
        if (!min_valid) {
            [self.validationStates addObject:kPMValidationStatusMinimumLengthError];
        }
        if (!max_valid) {
            [self.validationStates addObject:kPMValidationStatusMaximumLengthError];
        }
        
    }
    
    return self.isValid;
}


+ (NSString *)type {
    
    return @"PMValidationTypeLength";
}


@end
