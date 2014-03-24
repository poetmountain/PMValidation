//
//  PMValidationLengthType.h
//  
//
//  Created by Brett Walker on 6/9/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationType.h"

/**
 This validation class validates a target string based on minimum or maximum length constraints. Either constraint can be used alone, or can be used together.

 */

@interface PMValidationLengthType : PMValidationType


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


///-----------------------------------------
/// @name Configuring Validation Constraints
///-----------------------------------------

/**
 Represents the minimum number of characters allowed in the string to validate.
 
 @discussion This constraint is ignored unless assigned a value. Assigning this property to `kPMValidationIgnoreLengthConstraint` will explicitly inform PMValidationLengthType to ignore this constraint.
 
 */
@property (readwrite, assign) NSInteger minimumCharacters;

/**
 Represents the maximum number of characters allowed in the string to validate.
 
 @discussion This constraint is ignored unless assigned a value. Assigning this property to `kPMValidationIgnoreLengthConstraint` will explicitly inform PMValidationLengthType to ignore this constraint.
 
 */
@property (readwrite, assign) NSInteger maximumCharacters;


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


///--------------------
/// @name Constants
///--------------------

/**
 Represents a validation state where the target string is less than the minimum number of allowed characters.
*/
extern NSString *const kPMValidationStatusMinimumLengthError;

/**
 Represents a validation state where the target string is greater than the maximum number of allowed characters.
*/
extern NSString *const kPMValidationStatusMaximumLengthError;

extern NSInteger const kPMValidationIgnoreLengthConstraint;


@end
