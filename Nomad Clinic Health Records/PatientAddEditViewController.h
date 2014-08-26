//
//  PatientAddEditViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/26/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Patient, Clinic;

@interface PatientAddEditViewController : UIViewController

/**
 * Initializes the view controller for editing an existing patient and 
 * default clinic.  This is the designated initializer.
 *
 * @param p Patient to fill in UI fields from.
 * @param c Default clinic for UI
 */
- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil
                      ForPatient:(Patient*)p andClinic:(Clinic*)c;

/**
 * Initializes the view controller for editing an existing patient.
 *
 * @param p Patient to fill in UI fields from.
 */
- (instancetype) initForPatient:(Patient*)p;

/**
 * Initializes a view controller for a new patient for a given clinic.
 *
 * @param c Clinic that the patient defaults to. Can be nil, in which case
 *          the default is the unspecified (usually the first clinic returned by Core Data)
 */
- (instancetype) initForNewPatientAtClinic:(Clinic *)c;
@end
