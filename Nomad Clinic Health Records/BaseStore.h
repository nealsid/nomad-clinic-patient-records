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

/*
 * Returns all entities with unspecified sort order.
 *
 */
- (NSArray*) entities;

/*
 * Returns all entities with a given predicate.
 *
 */
- (NSArray*) entitiesWithPredicate:(NSPredicate*)predicate;

/**
 * Returns all entities sorted by the given sort key, in ascending/descending order.
 *
 * @param sortKey Key to sort by. Can be nil.  Can be a list of comma-separated sort keys.
 * @param ascending Whether sort is ascending or descending (ignored if first param is nil).
 */
- (NSArray*) entitiesWithSortKey:(NSString*) sortKey ascending:(BOOL)ascending;

/**
 * Returns all entities sorted by the given sort key, in
 * ascending/descending order, and with an optional predicate.
 *
 * @param sortKey Key to sort by. Can be nil.  Can be a list of comma-separated sort keys.
 * @param ascending Whether sort is ascending or descending (ignored if first param is nil).
 * @param predicate An NSPredicate to add to the query. Can be nil.
 */
- (NSArray*) entitiesWithSortKey:(NSString*) sortKey ascending:(BOOL)ascending andPredicate:(NSPredicate*)predicate;

/**
 * Saves outstanding CoreData changes
 */
- (void) saveChanges;

/**
 * Follows a 1-to-many CoreData relationship to find related entities, and
 * returns the most recent one according to the specified date property name.
 *
 * @param relatedEntityName The name of the related entities.
 * @param mo The NSManagedObject on the source side of the relation.
 * @param relationName The name of the property in the schema of
 *                     relatedEntityName that points to mo
 * @param dateField The field that specifies the date field in the
 *                  related entity's schema.
 *
 * @returns Most recent related entity or nil if none exist.
 */
- (NSManagedObject*) mostRecentRelatedEntity:(NSString*) relatedEntityName
                                 forInstance:(NSManagedObject*) mo
                                byRelationName:(NSString *) relationName
                                   dateField:(NSString*) dateField;

/**
 * Follows a 1 to many CoreData relationship to find related entities.
 *
 * @param relatedEntityName The name of the relation
 * @param mo The managed Object on the source side of the relation
 * @param relationName The name of the property in the schema of
 *                     relatedEntityName that points to mo
 * @param sortKey Sort key for the result set (can be nil).  Right now
 *                we always sort in descending order.
 *
 * @returns Array of results
 */
- (NSArray*) relatedEntities:(NSString*) relatedEntityName
                 forInstance:(NSManagedObject*) mo
              byRelationName:(NSString*) relationName
                     sortKey:(NSString*) sortKey;

/**
 * Follows a 1 to many CoreData relationship to find related entities, with
 * unspecified sort order in results.
 *
 * @param relatedEntityName The name of the relation
 * @param mo The managed Object on the source side of the relation
 * @param relationName The name of the property in the schema of
 *                     relatedEntityName that points to mo
 *
 * @returns Array of results
 */
- (NSArray*) relatedEntities:(NSString*) relatedEntityName
                 forInstance:(NSManagedObject*) mo
              byRelationName:(NSString*)relationName;

- (NSManagedObject*) newEntity;

- (void)removeEntity:(NSManagedObject *) obj;

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
