//
//  PMValidationUnit.h
//
//  Created by Brett Walker on 6/7/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 PMValidationUnit handles the validation of an individual object, such as a static string or a UIKit text object. One or more `PMValidationType` subclasses can be registered and used to validate the target object, and PMValidationUnit can provide an overall validation status.
 
 For validating a single static string, interfacing with this class is adequate. If you plan to validate UIKit text objects, or if you have many strings and need an aggregate validation status, it is easier to use `PMValidationManager`.
 
*/

@class PMValidationType;

@interface PMValidationUnit : NSObject


///----------------------------------
/// @name Creating an Instance
///----------------------------------

/**
 Returns an auto-released instance of this class
*/
+ (instancetype) validationUnit;


///--------------------------------------
/// @name Initializing a PMValidationUnit
///--------------------------------------

/**
 Initializes a new PMValidationUnit object, registering the provided PMValidationType objects and setting the identifier.
 
 @param validationTypes The PMValidationType subclasses that should be used to validate
 
 @param targetIdentifier The string by which to identify this instance with a `PMValidationManager` instance.
 
 @return A new instance of this class
 
 */
- (instancetype)initWithValidationTypes:(NSOrderedSet *)validationTypes identifier:(NSString *)targetIdentifier;


///---------------------
/// @name Identification
///---------------------

/** 
 Used to identify this instance with `PMValidationManager`
*/
@property (nonatomic, copy) NSString *identifier;


///----------------------------------
/// @name Managing Validation Types
///----------------------------------

/**
 Registers a `PMValidationType` subclass with this instance.
 
 @param validationType A class or subclass instance of `PMValidationType`.
 
*/
- (void)registerValidationType:(PMValidationType *)validationType;

/**
 Clears all registered validation types.
*/
- (void)clearValidationTypes;

/**
 Finds a `PMValidationType` associated with a provided identifier
 
 @param theIdentifier The string associated with the `PMValidationType` which was provided during the initWithValidationTypes or registerValidationType methods.
 
 @return The `PMValidationType` instance, or nil if none was found for the provided identifier.
 
*/
- (PMValidationType *)validationTypeForIdentifier:(NSString *)theIdentifier;



///---------------------------
/// @name Validating an Object
///---------------------------

/**
 Initiates validation update based on the specified string.
 
 @param text The text to validate
 
 @discussion Validation updates are provided by listening to `PMValidationUnitUpdateNotification` notifications.
 
*/
- (void)validateText:(NSString *)text;


/**
 Boolean getter denoting the overall validation status of all `PMValidationType` instances registered with this instance. A value of `YES` denotes that every validation type test has passed.
 */
@property (nonatomic, assign) BOOL isValid;

/**
 A `NSDictionary` of validation errors for each `PMValidationType` subclass which currently fails validation.
 */
@property (nonatomic, strong) NSDictionary *errors;

/**
 Boolean getter/setter which controls whether the instance will perform validation. When enabled is set to `NO`, no validation will occur and update notifications will not be sent.
 */
@property (nonatomic, assign) BOOL enabled;


///---------------------------
/// @name Notification Methods
///---------------------------

/** 
 Called when the text of an observed UIKit text object has changed.
 
 @param notification The system notification, either `UITextFieldTextDidChangeNotification` or `UITextViewTextDidChangeNotification`.
 
*/
- (void)textDidChangeNotification:(NSNotification *)notification;

/**
 Called when a PMValidationType object has updated its validation
 
 @param notification The notification sent by a PMValidationType subclass.
 
*/
- (void)validationUnitStatusUpdatedNotification:(NSNotification *)notification;


///--------------------
/// @name Notifications
///--------------------

/**
 This notification is fired when a particular `PMValidationType` has updated its validation of a registered object.
 
 - userInfo dict:
    - key: _errors_, value: A `NSDictionary` of validation states for each `PMValidationType` subclass.
 
*/
extern NSString *const PMValidationUnitUpdateNotification;




@end
