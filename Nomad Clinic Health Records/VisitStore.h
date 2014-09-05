//
//  PatientVisitStore.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/29/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patient.h"
#import "Visit.h"

@interface VisitStore : NSObject

/**
 * Returns an application wide PatientVisitStore singleton.
 *
 * @returns PatientVisitStore that is shared for every consumer in the app.
 */
+ (instancetype) sharedVisitStore;

/**
 * Fetches PatientVisits from store and returns them as an array
 *
 * @param p A patient to fetch visits for.  If nil, no visits are returned.
 * @returns NSArray of PatientVisits
 */
- (NSArray*) visitsForPatient:(Patient*)p;

/**
 * Fetches PatientVisitNotes from store and returns them as an array
 *
 * @param pv A PatientVisit to fetch visits for. Required.
 * @returns NSArray of PatientVisitNote objects.
 */
- (NSArray*) notesForVisit:(Visit*)visit;

/**
 * Fetches the most recent patient visit for a patient.
 *
 * @param p A Patient to fetch the most recent patient visit.  Required.
 * @returns The most recent patient visit.
*/
- (Visit*) mostRecentVisitForPatient:(Patient*)p;

/**
 * Saves all outstanding changes to the underlying store
 *
 * @returns none
 */
- (void) saveChanges;

/**
 * Creates a new Visit that is stored in the data store.
 *
 * @param p A Patient to create the visit for.
 * @returns PatientVisit object
 */
- (Visit*) newVisitForPatient:(Patient*) p atClinic:(Clinic *) c;

/**
 * Removes a PatientVisit from the PatientVisitStore
 *
 * @param p A PatientVisit to remove (must be an NSManagedObject)
 * @return none
 */
- (void)removeVisit:(Visit*)v;

@end
