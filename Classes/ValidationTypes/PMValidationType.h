//
//  PMValidationType.h
//
//  Created by Brett Walker on 6/8/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This is the base validation class. This base class has no inherent validation test, and will always return `YES` for any string sent to the `isTextValid:` method. All other validation classes inherit from this class.
 
 ## Subclassing
 
 If you want to create a custom validation class, you should inherit from this class. You will need to override the `validator` class method and provide an autoreleased instance of your own class, and also the `type` class method to provide a custom identification string for your subclass. Finally, you'll need to override the `isTextValid:` method to provide your own validation tests.
 
*/

@interface PMValidationType : NSObject


///----------------------------------
/// @name Creating an Instance
///----------------------------------

/**
 Returns an auto-released instance of this class.
 
 @discussion All subclasses of PMValidationType should override this method to return an instance of the subclass.
 
 */
+ (id) validator;


///---------------------------
/// @name Validating an Object
///---------------------------


/**
 Calling this method runs a validation pass on the provided text.
 
 @param text The string to be validated.
 
 @discussion Subclasses should override this method to provide their own validation. The method always returns `YES` on this base class.
 
 @return A boolean representing the validation state.
 
*/
-(BOOL)isTextValid:(NSString *)text;


/**
 Boolean getter representing the validation state of this instance. A value of `YES` denotes that the validation test has passed.
 */
@property (readwrite, assign) BOOL isValid;


/*
 A collection containing the current validation states. This can also contain error states, if the validation test did not pass.
 */
@property (nonatomic, retain) NSMutableSet *validationStates;


/**
 Boolean getter representing whether the `PMValidationType` class or subclass sends updates.
 */
@property (readwrite, assign) BOOL sendsUpdates;


///---------------------
/// @name Identification
///---------------------

/**
 Identifies the type of this class to a `PMValidationUnit` instance.
 
 @discussion All subclasses of PMValidationType should override this method to define their own type string.
 
 */
+ (NSString *)type;


/**
 Identifies this instance in a `PMValidationUnit` to which it is registered.
 */
@property (nonatomic, copy) NSString *identifier;


///--------------------
/// @name Notifications
///--------------------

/**
 This notification is fired when validation has updated through another mechanism than calling the `isTextValid:` method.
 
 - userInfo dict:
    - key: _status_, value: A boolean representing the current validation state.
 
*/
extern NSString *const PMValidationUpdateNotification;


///--------------------
/// @name Constants
///--------------------

/**
 Represents a passing validation state.
*/
extern NSString *const kPMValidationStatusValid;

/**
 Represents a failing validation state.
*/
extern NSString *const kPMValidationStatusInvalid;


@end
