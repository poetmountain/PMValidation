//
//  PMValidationEmailType.m
//  
//
//  Created by Brett Walker on 6/8/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationEmailType.h"

@implementation PMValidationEmailType


// returns a new instance of PMValidationEmailType
+ (instancetype)validator {
    
    PMValidationEmailType *val = [[PMValidationEmailType alloc] init];
    
    return val;
    
}


- (BOOL)isTextValid:(NSString *)text {
    
    NSError *error = nil;
    
    // while Unicode characters are permissible in user and domain sections of an e-mail address, they must be encoded and use IDNA.
    // (see: http://en.wikipedia.org/wiki/Unicode_and_e-mail#Unicode_support_in_message_headings )
    // this validation does not parse or check thusly-encoded strings for well-formedness (yet?)
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[+\\w\\.\\-'!#$%&*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+(\\.[a-zA-Z]{2,})+$" options:NSRegularExpressionCaseInsensitive error:&error];
    
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
