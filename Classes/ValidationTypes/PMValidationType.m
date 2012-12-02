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


@synthesize isValid;
@synthesize validationStates;
@synthesize sendsUpdates;
@synthesize identifier;


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


// returns a new, autoreleased instance of PMValidationType
+ (id)validator {
    
    PMValidationType *val = [[[PMValidationType alloc] init] autorelease];
    
    return val;
    
}


-(void)dealloc {
    
    [validationStates release];
    [identifier release];
    
    [super dealloc];
}


#pragma mark - methods


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
