//
//  ValidationObjectVC.h
//  imprints
//
//  Created by Brett Walker on 6/11/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMValidationUnit;

@interface ValidationUnitStatusIndicatorVC : UIViewController

@property (nonatomic, retain) UIImageView *indicatorIcon;


- (void) registerWithValidationUnit:(PMValidationUnit *)validationUnit;
- (void) updateIndicatorForStatus:(BOOL)isValid;
- (void) validationStatusDidChange:(NSNotification *)notification;

@end
