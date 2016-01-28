//
//  PMValidationStringMatchType.m
//  
//
//  Created by Brett Walker on 6/9/12.
//  Copyright (c) 2012-2016 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationStringCompareType.h"

@implementation PMValidationStringCompareType

NSString *const kPMValidationComparisonTypeEquals = @"PMValidationComparisonTypeEquals";
NSString *const kPMValidationComparisonTypeNotEquals = @"PMValidationComparisonTypeNotEquals";


#pragma mark - Lifecycle methods

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.comparisonString = @"";
        self.comparisonType = kPMValidationComparisonTypeEquals;
    }
    
    return self;
}




#pragma mark - Validator methods



- (BOOL)isTextValid:(NSString *)text {
    
    
    if (self.comparisonType == kPMValidationComparisonTypeEquals) {
        self.isValid = [text isEqualToString:self.comparisonString];
    } else if (self.comparisonType == kPMValidationComparisonTypeNotEquals) {
        self.isValid = ![text isEqualToString:self.comparisonString];
    }
        
    return self.isValid;
}


#pragma mark - Class methods

// returns a new instance of PMValidationStringMatchType
+ (instancetype)validator {
    
    PMValidationStringCompareType *val = [[PMValidationStringCompareType alloc] init];
    
    return val;
    
}

+ (NSString *)type {
    
    return @"PMValidationTypeStringCompare";
}




@end
