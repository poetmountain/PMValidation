//
//  PMValidationRegexType.m
//
//  Created by Brett Walker on 6/13/12.
//  Copyright (c) 2012-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationRegexType.h"

@implementation PMValidationRegexType


#pragma mark - Lifecycle methods

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.regexString = @"";
    }
    
    return self;
}



#pragma mark - Validator methods


// returns a new instance of PMValidationRegexType
+ (instancetype)validator {
    
    PMValidationRegexType *val = [[PMValidationRegexType alloc] init];
    
    return val;
    
}


- (BOOL)isTextValid:(NSString *)text {
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.regexString options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSInteger num_matches = [regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    self.isValid = (num_matches == 1);
    
    // update states
    [self.validationStates removeAllObjects];
    (self.isValid) ? ([self.validationStates addObject:kPMValidationStatusValid])
                   : ([self.validationStates addObject:kPMValidationStatusInvalid]);
    
    
    return self.isValid;
}



+ (NSString *)type {
    
    return @"PMValidationTypeRegex";
}

@end
