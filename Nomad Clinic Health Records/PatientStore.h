//
//  PatientStore.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/21/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Patient.h"

@interface PatientStore : NSObject

/**
 * Returns an application wide PatientStore singleton.
 *
 * @returns PatientStore that is shared for every consumer in the app.
 */
+ (instancetype) sharedPatientStore;

/**
 * Fetches all patients from store and returns them as an array
 *
 * @returns NSArray of Patients
 */
- (NSArray*) patients;

/**
 * Fetches patients for a given clinic and returns them as an array
 *
 * @param c Clinic to fetch patients for.
 * @returns NSArray of Patients
 */
- (NSArray*) patientsForClinic:(Clinic*)c;

/**
 * Saves all outstanding changes to the underlying store
 *
 * @returns none
 */
- (void) saveChanges;

/**
 * Creates a new Patient that is stored in the data store.
 *
 * @returns Patient object
 */
- (Patient*) newPatient;

/**
 * Removes a Patient from the PatientStore
 *
 * @param p A Patient to remove (must be an NSManagedObject)
 * @return none
 */
- (void)removePatient:(Patient*)p;
@end
