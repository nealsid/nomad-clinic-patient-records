//
//  NEMRNewPatientViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@protocol NEMRPatientViewControllerDelegate;

@interface NEMRPatientViewController : UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                     andPatient:(Patient*)p
                   withDelegate:(id<NEMRPatientViewControllerDelegate>)delegate;

@end

@protocol NEMRPatientViewControllerDelegate

- (void) patientViewControllerSave:(NEMRPatientViewController*)patientViewController
               patient:(Patient*)p;
- (void) patientViewControllerCancel:(NEMRPatientViewController*)patientViewController;

@end