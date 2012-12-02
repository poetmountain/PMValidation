//
//  PMValidationEmailType.m
//  
//
//  Created by Brett Walker on 6/8/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationEmailType.h"

@implementation PMValidationEmailType


// returns a new, autoreleased instance of PMValidationEmailType
+ (id) validator {
    
    PMValidationEmailType *val = [[[PMValidationEmailType alloc] init] autorelease];
    
    return val;
    
}


-(BOOL) isTextValid:(NSString *)text {
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[+\\w\\.\\-']+@[a-zA-Z0-9-]+(\\.[a-zA-Z]{2,})+$" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSInteger num_matches = [regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    self.isValid = (num_matches == 1);
    
    // update states
    [self.validationStates removeAllObjects];
    (self.isValid) ? ([self.validationStates addObject:kPMValidationStatusValid])
                   : ([self.validationStates addObject:kPMValidationStatusInvalid]);
    
    return self.isValid;
}


+ (NSString *)type {
    
    return @"PMValidationTypeEmail";
}


@end
