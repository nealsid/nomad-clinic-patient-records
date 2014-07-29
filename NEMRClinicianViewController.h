//
//  NEMRClinicianViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/28/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clinician.h"

@protocol NEMRClinicianViewControllerDelegate;

@interface NEMRClinicianViewController : UIViewController

/**
 * Designated initializer for the Clinician view controller.
 *
 * @param andClinician The clinician to view/edit
 * @param withDelegate The object that conforms to
 *                     NEMRPatientViewControllerDelegate
 * @returns An initialized viewcontroller
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                   andClinician:(Clinician*)c
                   withDelegate:(id<NEMRClinicianViewControllerDelegate>)delegate;

@end

@protocol NEMRClinicianViewControllerDelegate

- (void) clinicianViewControllerSave:(NEMRClinicianViewController*)clinicianViewController
               clinician:(Clinician*)c;
- (void) clinicianViewControllerCancel:(NEMRClinicianViewController*)clinicianViewController;

@end
