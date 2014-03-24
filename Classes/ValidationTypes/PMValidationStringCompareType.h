//
//  PMValidationStringMatchType.h
//  
//
//  Created by Brett Walker on 6/9/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationType.h"

/**
 This validation class validates the target string by comparing it to another string. Set the `comparisonType` property to one of the available comparison constants to modify how the strings are compared.

 */

@interface PMValidationStringCompareType : PMValidationType

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
 The string to compare the target validation string to.
 */
@property (nonatomic, copy) NSString *comparisonString;

/**
 Defines the string comparison to use for the validation test.
 
 @discussion Valid values are either `kPMValidationComparisonTypeEquals` or `kPMValidationComparisonTypeNotEquals`. The default value is `kPMValidationComparisonTypeEquals`.
 
 */
@property (nonatomic, copy) NSString *comparisonType;


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
 This comparison type specifies that the target validation string must equal to the `comparisonString` property.
*/
extern NSString *const kPMValidationComparisonTypeEquals;

/**
 This comparison type specifies that the target validation string must *not* equal the `comparisonString` property.
*/
extern NSString *const kPMValidationComparisonTypeNotEquals;


@end
