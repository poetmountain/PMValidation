1.3.1
=====
* Fixed PMValidationUnits added to PMValidationManager via 'addUnit:' not being listened for validation update notifications. Normally this is not necessary for non-UIKit units, but may be needed for custom subclasses which trigger their own updates.

1.3.0
=====
* Added ability to add and remove PMValidationUnit instances from a PMValidationManager instance using the new addUnit:, addUnit: identifier:, and removeUnitForIdentifier: methods.
* Added enabled boolean property to PMValidationUnit, which disables validation when set to NO. PMValidationManager will skip units thusly disabled and not count them toward the global validation state.
* General syntactical cleanup
* Updated tests to test new methods.
* Updated README for clarity

1.2.0
=====
The iOS Minimum Target for PMValidation has been bumped to 6.0. This relieves the workaround needed for dispatch_queues when using PMValidation in projects targeting iOS 6 or greater. If you need compatibility with iOS 5.0, please use 1.1.3.

Other changes:
* Fixed PMValidationUITextCompareType not calling super version of isTextValid method
* Added test for fix
* Updated README
* Updated Cocoapods dependencies for tests
* Added PMValidation podspec to repo

1.1.3
=====
* Added tests (Specta/Expecta) for every class! 🍺
* PMValidationEmailType: Added some characters to the validation which are rarely used, but valid under RFC 5322.
* PMValidationLengthType: Specifying a value for maximumCharacters that is lower than minimumCharacters will now cause the maximumCharacters test to be ignored.

1.1.2
=====
* PMValidationUnit: Changed the validateText method to use fast enumeration instead of the block enumerator form. Performance comparisons bear out that fast enumeration is the better choice for most reasonable use cases, and avoids concurrency issues.
* Changed all class constructors to use return instancetype instead of id.
* Fixed some NSInteger/NSUInteger mismatches.
* Updated comments to reflect this and some previous changes.

1.1.1
=====
* Fixed type mismatch bug

1.1.0
=====
* ARC compatibility

1.0.0
=====
* First release