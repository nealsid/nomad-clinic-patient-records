//
//  BaseStore.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/3/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient, Clinic;

@interface BaseStore : NSObject

@property (nonatomic, strong) NSString* entityName;

/**
 * Returns an application wide Store singleton for a given entity
 *
 * @returns store that is shared for every consumer in the app for each entity
 */
+ (instancetype) sharedStoreForEntity:(NSString *) entityName;

- (NSArray*) entities;

- (void) saveChanges;

/**
 * Follows a 1-to-many CoreData relationship to find related entities, and
 * returns the most recent one according to the specified date property name.
 *
 * @param relatedEntityName The name of the related entities.
 * @param mo The NSManagedObject on the source side of the relation.
 * @param dateField The field that specifies the date field in the
 *                  related entity's schema.
 *
 * @returns Most recent related entity or nil if none exist.
 */
- (NSManagedObject*) mostRecentRelatedEntity:(NSString*) relatedEntityName
                                 forInstance:(NSManagedObject*) mo
                                   dateField:(NSString*) dateField;

/**
 * Follows a 1 to many CoreData relationship to find related entities.
 *
 * @param relatedEntityName The name of the relation
 * @param mo The managed Object on the source side of the relation
 * @param sortKey Sort key for the result set (can be nil).  Right now
 *                we always sort in descending order.
 *
 * @returns Array of results
 */
- (NSArray*) relatedEntities:(NSString*) relatedEntityName
                 forInstance:(NSManagedObject*) mo
                     sortKey:(NSString*) sortKey;

/**
 * Follows a 1 to many CoreData relationship to find related entities, with
 * unspecified sort order in results.
 *
 * @param relatedEntityName The name of the relation
 * @param mo The managed Object on the source side of the relation
 *
 * @returns Array of results
 */
- (NSArray*) relatedEntities:(NSString*) relatedEntityName
                 forInstance:(NSManagedObject*) mo;

- (NSManagedObject*) newEntity;

/**
 * Creates a new related entity for a given NSManagedObject.
 *
 * @param relatedEntityName Name of the related entity type.
 * @param mo The managed object that the new entity is related to.
 * @returns The new NSManagedObject that is related to MO.
 */
- (NSManagedObject*) newRelatedEntity:(NSString*) relatedEntityName
                     forManagedObject:(NSManagedObject*) mo;

- (void)removeEntity:(NSManagedObject *)obj;

/**
 * Helper method to find patients who have been seen at a clinic. It's
 * separate because the CoreData syntax for creating predicates on related entities
 * requires a SUBQUERY.
 *
 * @param C The clinic to filter visits by.
 * @return An array of patients who have visits at the given clinic.
 */
- (NSArray*) patientsForClinic:(Clinic*) c;

@end
