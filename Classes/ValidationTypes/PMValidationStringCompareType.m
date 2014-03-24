//
//  PMValidationStringMatchType.m
//  
//
//  Created by Brett Walker on 6/9/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationStringCompareType.h"

@implementation PMValidationStringCompareType

NSString *const kPMValidationComparisonTypeEquals = @"PMValidationComparisonTypeEquals";
NSString *const kPMValidationComparisonTypeNotEquals = @"PMValidationComparisonTypeNotEquals";

@synthesize comparisonString;
@synthesize comparisonType;

#pragma mark - Lifecycle methods

-(id)init {
    
    self = [super init];
    if (self) {
        self.comparisonString = @"";
        self.comparisonType = kPMValidationComparisonTypeEquals;
    }
    
    return self;
}

-(void)dealloc {
    
    [comparisonString release];
    [comparisonType release];
    
    [super dealloc];
}


#pragma mark - Validator methods



-(BOOL) isTextValid:(NSString *)text {
    
    
    if (self.comparisonType == kPMValidationComparisonTypeEquals) {
        self.isValid = [text isEqualToString:self.comparisonString];
    } else if (self.comparisonType == kPMValidationComparisonTypeNotEquals) {
        self.isValid = ![text isEqualToString:self.comparisonString];
    }
        
    return self.isValid;
}


#pragma mark - Class methods

// returns a new, autoreleased instance of PMValidationStringMatchType
+ (id) validator {
    
    PMValidationStringCompareType *val = [[[PMValidationStringCompareType alloc] init] autorelease];
    
    return val;
    
}

+ (NSString *)type {
    
    return @"PMValidationTypeStringCompare";
}




@end
