//
//  PMValidationUITextCompareType.h
//
//  Created by Brett Walker on 6/9/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import "PMValidationStringCompareType.h"

/**
 This validation class validates the target string by comparing it to a UIKit text object. It works by listening for text change notifications from either `UITextField` or `UITextView`, and broadcasts validation updates to any listening `PMValidationUnit` instances.
 
 ## Subclassing
 
 To subclass, please override the `textDidChangeNotification:` method to support your custom UI object's notification.
 
*/

@interface PMValidationUITextCompareType : PMValidationStringCompareType

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
/// @name Tracking External Objects
///-----------------------------------------

/**
 The previous string value to compare against.
 
 */
@property (nonatomic, copy) NSString *lastStringValue;

/**
 Registers a `UITextField` instance whose text value should be used to compare the target validation string against.
 
 @param textField The `UITextField` instance to listen to `UITextFieldTextDidChangeNotification` notifications from.
 
 */
- (void) registerTextFieldToMatch:(UITextField *)textField;

/**
 Registers a `UITextView` instance whose text value should be used to compare the target validation string against.
 
 @param textField The `UITextView` instance to listen to `UITextViewTextDidChangeNotification` notifications from.
 
 */
- (void) registerTextViewToMatch:(UITextView *)textView;



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



///---------------------------
/// @name Notification Methods
///---------------------------

/**
 This notification is fired when a text change update is received from a registered UI object.
*/
- (void) textDidChangeNotification:(NSNotification *)notification;

@end
