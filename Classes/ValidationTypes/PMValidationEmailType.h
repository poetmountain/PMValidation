//
//  PMValidationEmailType.h
//  
//
//  Created by Brett Walker on 6/8/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationType.h"

/**
 This validation class validates a target string as an e-mail address, determining whether it is well-formed.
*/

@interface PMValidationEmailType : PMValidationType

///----------------------------------
/// @name Creating an Instance
///----------------------------------

/**
 Returns an auto-released instance of this class.
 
 @discussion All subclasses should override this method to return an instance of the subclass.
 
 */
+ (id) validator;


///---------------------
/// @name Identification
///---------------------

/**
 Identifies the type of this class to a `PMValidationUnit` instance.
 
 @discussion All subclasses should override this method to define their own type string.
 
 */
+ (NSString *)type;


///---------------------------
/// @name Validating an Object
///---------------------------


/**
 Calling this method runs a validation pass on the provided text.
 
 @param text The string to be validated.
 
 @discussion Subclasses should override this method to provide their own validation.
 
 @return A boolean representing the validation state.
 
 */
-(BOOL)isTextValid:(NSString *)text;


@end
