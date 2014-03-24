//
//  PMValidationType.m
//
//  Created by Brett Walker on 6/8/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationType.h"


@implementation PMValidationType

NSString *const kPMValidationStatusValid = @"PMValidationStatusValid";
NSString *const kPMValidationStatusInvalid = @"PMValidationStatusInvalid";

NSString *const PMValidationUpdateNotification = @"PMValidationUpdateNotification";


#pragma mark - Lifecycle methods

-(id)init {
    
    self = [super init];
    if (self) {
        self.validationStates = [NSMutableSet setWithObject:kPMValidationStatusInvalid];
        self.sendsUpdates = NO;
        self.identifier = @"";
    }
    
    return self;
}


// returns a new instance of PMValidationType
+ (instancetype)validator {
    
    PMValidationType *val = [[PMValidationType alloc] init];
    
    return val;
    
}



#pragma mark - public methods


// base class, no validation occurs so just return yes
-(BOOL) isTextValid:(NSString *)text {
    
    self.isValid = YES;
    // update states
    [self.validationStates removeAllObjects];
    [self.validationStates addObject:kPMValidationStatusValid];
    
    return self.isValid;
}


+ (NSString *)type {
    
    return @"PMValidationTypeBase";
}

@end
