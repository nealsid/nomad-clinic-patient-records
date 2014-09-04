//
//  BaseStore.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/3/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

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

- (NSManagedObject*) newEntity;

- (void)removeEntity:(NSManagedObject *)obj;

@end
