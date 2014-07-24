//
//  ValidationObjectVC.m
//  imprints
//
//  Created by Brett Walker on 6/11/12.
//  Copyright (c) 2012 Poet & Mountain, LLC. All rights reserved.
//

#import "ValidationUnitStatusIndicatorVC.h"
#import "PMValidationUnit.h"

@implementation ValidationUnitStatusIndicatorVC


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    CGRect icon_frame = CGRectMake(0, 0, 30, 30);
    self.indicatorIcon = [[UIImageView alloc] initWithFrame:icon_frame];
    self.indicatorIcon.userInteractionEnabled = NO;

    [self.view addSubview:self.indicatorIcon];

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}



#pragma mark - General methods

- (void)registerWithValidationUnit:(PMValidationUnit *)validationUnit {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validationStatusDidChange:) name:PMValidationUnitUpdateNotification object:validationUnit];
}


- (void)updateIndicatorForStatus:(BOOL)isValid {
    
    UIImage *icon_image;
    if (isValid) {
        icon_image = nil;
    } else {
        NSString *invalid_path = [[NSBundle mainBundle] pathForResource:@"invalid_icon" ofType:@"png"];
        icon_image = [UIImage imageWithContentsOfFile:invalid_path];
    }
    
    self.indicatorIcon.image = icon_image;
    
}


#pragma mark - Notifications

-(void)validationStatusDidChange:(NSNotification *)notification {
    
    PMValidationUnit *unit = (PMValidationUnit *)notification.object;
    
    //NSLog(@"%@ is %i", unit.identifier, unit.isValid);
    
    [self updateIndicatorForStatus:unit.isValid];

}



@end
