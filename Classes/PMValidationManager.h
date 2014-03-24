//
//  PMValidationManager.h
//  
//
//  Created by Brett Walker on 6/7/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 PMValidationManager manages the operation of `PMValidationUnit` instances, and acts as the interface for receiving validation updates. If you need to validate a UIKit text object, or you have many strings you need to validate simultaneously, this class is preferred to using `PMValidationUnit` directly.
 
*/

@class PMValidationUnit;

@interface PMValidationManager : NSObject <UITextViewDelegate, UITextFieldDelegate>



///-------------------------------------
/// @name Creating an Instance
///-------------------------------------

/**
 Returns an auto-released instance of this class
*/
+ (PMValidationManager *)validationManager;


///----------------------------------
/// @name Managing Validation Objects
///----------------------------------

/**
 Convenience method to register a `UITextField` to be validated.
 
 @param textField The `UITextField` to validate
 @param validationTypes A set of `PMValidationType` subclasses that specify how to validate the `UITextField`.
 @param identifier A string to identify this validation set by.
 
 @return A new `PMValidationUnit` instance which handles validation for this set.
 
*/
- (PMValidationUnit *)registerTextField:(UITextField *)textField forValidationTypes:(NSSet *)validationTypes identifier:(NSString *)identifier;

/**
 Convenience method to register a `UITextView` to be validated.
 
 @param textView The `UITextView` to validate
 @param validationTypes A set of `PMValidationType` subclasses that specify how to validate the `UITextView`.
 @param identifier A string to identify this validation set by.
 
 @return A new `PMValidationUnit` instance which handles validation for this set.
 
*/
- (PMValidationUnit *)registerTextView:(UITextView *)textView forValidationTypes:(NSSet *)validationTypes identifier:(NSString *)identifier;

/**
 Registers an object to be validated. 
 
 @param object The object to be validated.
 @param validationTypes A set of `PMValidationType` subclasses that specify how to validate the object.
 @param notificationType The name of the notification which a `PMValidationUnit` should listen to text updates for.
 @param identifier A string to identify this validation set by.
 
 @return A new `PMValidationUnit` instance which handles validation for this set.
 
 */
-(PMValidationUnit *)registerObject:(id)object forValidationTypes:(NSSet *)validationTypes objectNotificationType:(NSString *)notificationType identifier:(NSString *)identifier;

/**
 Finds a `PMValidationUnit` associated with a provided identifier
 
 @param identifier The string associated with the `PMValidationUnit` which was provided during the registerTextField or registerTextView methods.
 
 @return The associated `PMValidationUnit` instance, or nil if none was found for the provided identifier.
 
 */
- (PMValidationUnit *)unitForIdentifier:(NSString *)identifier;


///----------------------------------
/// @name Querying Validation State
///----------------------------------

/**
 Boolean getter representing the validation state of all registered `PMValidationUnit` instances. A value of `YES` denotes that every validation test has passed.
 */
@property (readwrite, assign) BOOL isValid;


///--------------------
/// @name Notifications
///--------------------


/**
 This notification is fired when the validation status of one of its `PMValidationUnit` instances has been updated. Its purpose is to communicate the current overall validation status of all of its registered `PMValidationUnit` instances.
 
 - userInfo dict:
    - key: _status_, value: a `BOOL` denoting the overall validation status of all registered units.
    - key: _units_, value: a NSDictionary of statuses for all registered units.
        - key: a `PMValidationUnit` identifier, value: a NSDictionary of this unit's validation status
            - key: _isValid_, value: current validation status of this `PMValidationUnit` object.
            - key: _errors_, value: a NSDictionary of validation errors, if any.
 
*/
extern NSString *const PMValidationStatusNotification;


@end
