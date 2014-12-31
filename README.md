PMValidation is a modular, extendable text validation library for iOS. It comes with several common validation types for often-used tasks like validating registration forms, however it was architected to be easily extended with your own validation types. For a preliminary (but functional) Swift version of this lib, see [PapersPlease](https://github.com/poetmountain/PapersPlease).

## Features

* Validate individual string objects or listen to changes from UIKit objects
* Modular – validation types can be used together to create complex validation constraints
* Extensible - Easily create your own validation types by subclassing PMValidationType
* Comes with several useful validation types to satisfy most validation needs
* Easily implement form validation by using PMValidationManager to register UIKit text input objects

## Overview

At its simplest, PMValidation starts with an instance of a PMValidationType subclass. These classes provide the validation logic, and can be used directly if you just need a single validation test on your string. PMValidationType can be subclassed to provide your own custom validation logic. If you have a more complex validation test requiring several PMValidationType subclasses and need to determine an overall validation state for a string, use the PMValidationUnit class. When you need to validate more than one string and determine a global validation state (e.g. a validation form), the PMValidationManager class is useful. This class controls one or more PMValidationUnit objects, providing an overall validation status and notification routing. This class also simplifies the validation of UIKit text input classes.

## Getting Started

The included [validation form example](https://github.com/poetmountain/PMValidation/tree/master/PMValidationDemo) project should give you a good overview of how PMValidation works.


### The basics

Here's a basic example, creating a string length constraint which passes validation while the string is between 4 and 8 characters.

``` objective-c
PMValidationLengthType *length_type = [PMValidationLengthType validator];
length_type.minimumCharacters = 4;
length_type.maximumCharacters = 8;

PMValidationUnit *unit = [PMValidationUnit validationUnit];
[unit registerValidationType:length_type];

// get validation status update
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validationStatusNotificationHandler:) name:PMValidationUnitUpdateNotification object:unit];
		
// listen for validation status updates    
- (void)validationStatusNotificationHandler:(NSNotification *)notification {
    
  PMValidationUnit *unit = (PMValidationUnit *)notification.object;

  if (!unit.isValid) {
  	NSDictionary *errors = [notification.userInfo valueForKey:@"errors"];
  }  
    
}


// validate the string 
[unit validateText:@"Velvet Underground"];
```

That example only uses one validation type class, but you can add as many as you want to create very complex validation tests. An alternative to chaining types together is to use the PMValidationRegexType class, which allows use of a regular expression as a validation test. For complex use cases this can be preferable – PMValidationEmailType uses a regular expression internally – but using more basic validation type classes together can provide greater readability and external customization. YMMV.

Validating static strings is cool, but let's hook up a PMValidationUnit to a UITextField so we can dynamically validate it as its text changes. While we could do this with just a PMValidationUnit, it's a bit easier to use PMValidationManager for this.

```objective-c
PMValidationManager *manager = [PMValidationManager validationManager];
PMValidationEmailType *email_type = [PMValidationEmailType validator];
PMValidationUnit *email_unit = [manager registerTextField:self.emailTextField
                                       forValidationTypes:[NSSet setWithObjects:email_type, nil]
                                               identifier:@"email"];
                                               
// get validation status update
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validationStatusNotificationHandler:) name:PMValidationStatusNotification object:self.validationManager];
		
    
- (void)validationStatusNotificationHandler:(NSNotification *)notification {
    
  BOOL is_valid = [(NSNumber *)[notification.userInfo objectForKey:@"status"] boolValue];
  if (!is_valid) {
  	NSDictionary *units = [notification.userInfo objectForKey:@"units"];
  	NSDictionary *email_dict = [units objectForKey:email_type.identifier];
  	NSDictionary *email_errors = [email_dict objectForKey:@"errors"];
  } 
    
}
```


### Class reference

<table>
  <tr><th colspan="2" style="text-align:center;">Management</th></tr>
  <tr>
    <td><a href="http://poetmountain.github.com/PMValidation/Classes/PMValidationUnit.html">PMValidationUnit</a></td>
    <td>PMValidationUnit handles the validation of one object at a time, such as a static string or a UIKit text object. It receives updates from one or more <tt>PMValidationType</tt> objects.</td>
  </tr>
  <tr>
    <td><a href="http://poetmountain.github.com/PMValidation/Classes/PMValidationManager.html">PMValidationManager</a></td>
    <td>PMValidationManager manages the operation of <tt>PMValidationUnit</tt> instances, and acts as the interface for receiving validation updates.</td>
  </tr>
	
  <tr><th colspan="2" style="text-align:center;">Validation Types</th></tr>
  <tr>
    <td><a href="http://poetmountain.github.com/PMValidation/Classes/PMValidationType.html">PMValidationType</a></td>
    <td>PMValidationType is the base validation class. This base class has no inherent validation test, and will always return YES for any string sent to the <tt>isTextValid:</tt> method. All other validation classes inherit from this base class.</td>
  </tr>
  <tr>
    <td><a href="http://poetmountain.github.com/PMValidation/Classes/PMValidationEmailType.html">PMValidationEmailType</a></td>
    <td>This validation class validates a target string as an e-mail address, determining whether it is well-formed.</td>
  </tr>
  <tr>
    <td><a href="http://poetmountain.github.com/PMValidation/Classes/PMValidationLengthType.html">PMValidationLengthType</a></td>
    <td>This validation class validates a target string based on minimum or maximum length constraints. Either constraint can be used alone, or can be used together.</td>
  </tr>
  <tr>
    <td><a href="http://poetmountain.github.com/PMValidation/Classes/PMValidationRegexType.html">PMValidationRegexType</a></td>
    <td>This validation class validates a target string with a regular expression.</td>
  </tr>
  <tr>
    <td><a href="http://poetmountain.github.com/PMValidation/Classes/PMValidationStringCompareType.html">PMValidationStringCompareType</a></td>
    <td>This validation class validates the target string by comparing it to another string.</td>
  </tr>
  <tr>
    <td><a href="http://poetmountain.github.com/PMValidation/Classes/PMValidationUITextCompareType.html">PMValidationUITextCompareType</a></td>
    <td>This validation class validates the target string by comparing it to a UIKit text object.</td>
  </tr>
			
  <tr>
</table>
		
## Credits

PMValidation was created by [Brett Walker](https://twitter.com/petsound) of [Poet & Mountain](http://poetmountain.com).

## Compatibility

* Requires iOS 6.0 or later
* PMValidation uses ARC.

## License

PMValidation is licensed under the MIT License.