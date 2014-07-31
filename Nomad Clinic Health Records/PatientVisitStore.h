//
//  PatientVisitStore.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/29/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patient.h"
#import "PatientVisit.h"

@interface PatientVisitStore : NSObject

/**
 * Returns an application wide PatientVisitStore singleton.
 *
 * @returns PatientVisitStore that is shared for every consumer in the app.
 */
+ (instancetype) sharedPatientVisitStore;

/**
 * Fetches PatientVisits from store and returns them as an array
 *
 * @param p A patient to fetch visits for, or nil for all visits.
 * @returns NSArray of PatientVisits
 */
- (NSArray*) patientVisitsForPatient:(Patient*)p;

/**
 * Saves all outstanding changes to the underlying store
 *
 * @returns none
 */
- (void) saveChanges;

/**
 * Creates a new PatientVisit that is stored in the data store.
 *
 * @returns PatientVisit object
 */
- (PatientVisit*) newPatientVisit;

/**
 * Removes a PatientVisit from the PatientVisitStore
 *
 * @param p A PatientVisit to remove (must be an NSManagedObject)
 * @return none
 */
- (void)removePatientVisit:(PatientVisit*)c;
@end
