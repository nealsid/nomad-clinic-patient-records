//
//  ClinicStore.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/22/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//


#import "Clinic.h"

#import <Foundation/Foundation.h>

@interface ClinicStore : NSObject

/**
 * Returns an application wide clinicStore singleton.
 *
 * @returns clinicStore that is shared for every consumer in the app.
 */
+ (instancetype) sharedClinicStore;

/**
 * Fetches clinics from store and returns them as an array
 *
 * @returns NSArray of clinics
 */
- (NSArray*) clinics;

/**
 * Saves all outstanding changes to the underlying store
 *
 * @returns none
 */
- (void) saveChanges;

/**
 * Creates a new clinic that is stored in the data store.
 *
 * @returns clinic object
 */
- (Clinic*) newClinic;

/**
 * Removes a clinic from the clinicStore
 *
 * @param c A Clinic to remove (must be an NSManagedObject)
 * @return none
 */
- (void)removeClinic:(Clinic*)c;
@end
