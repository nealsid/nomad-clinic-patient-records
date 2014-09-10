//
//  PatientAddEditViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/26/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Clinic, Patient, Village;

@interface PatientAddEditViewController : UIViewController

/**
 * Initializes the view controller for editing an existing patient and
 * default village.  This is the designated initializer.
 *
 * @param p Patient to fill in UI fields from.
 * @param v Default village for UI
 */
- (instancetype) initWithNibName:(NSString *) nibNameOrNil
                          bundle:(NSBundle *) bundleOrNil
                      forPatient:(Patient *) p
                       andVillage:(Village *) v
                        atClinic:(Clinic*) c;

/**
 * Initializes the view controller for editing an existing patient.
 *
 * @param p Patient to fill in UI fields from.
 */
- (instancetype) initForPatient:(Patient*) p;

/**
 * Initializes a view controller for a new patient for a given clinic.
 *
 * @param v Village that the patient defaults to. Can be nil, in which case
 *          the default is the unspecified (usually the first village returned
 *          by Core Data)
 */
- (instancetype) initForNewPatientInVillage:(Village *) v atClinic:(Clinic*)c;
@end
