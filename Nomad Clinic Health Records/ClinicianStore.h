//
//  ClinicianStore.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/21/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Clinician.h"

@interface ClinicianStore : NSObject

/**
 * Returns an application wide ClinicianStore singleton.
 *
 * @returns ClinicianStore that is shared for every consumer in the app.
 */
+ (instancetype) sharedClinicianStore;

/**
 * Fetches Clinicians from store and returns them as an array
 *
 * @returns NSArray of Clinicians
 */
- (NSArray*) clinicians;

/**
 * Saves all outstanding changes to the underlying store
 *
 * @returns none
 */
- (void) saveChanges;

/**
 * Creates a new Clinician that is stored in the data store.
 *
 * @returns Clinician object
 */
- (Clinician*) newClinician;

/**
 * Removes a Clinician from the ClinicianStore
 *
 * @param p A Clinician to remove (must be an NSManagedObject)
 * @return none
 */
- (void)removeClinician:(Clinician*)c;
@end
