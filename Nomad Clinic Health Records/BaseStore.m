//
//  BaseStore.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/3/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "BaseStore.h"
#import "NEMRAppDelegate.h"

@interface BaseStore ()

- (instancetype) initForEntityName:(NSString*)name;

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

@end

@implementation BaseStore

- (instancetype) initForEntityName:(NSString*)name {
  self = [super init];
  if (self) {
    self.entityName = name;
    NEMRAppDelegate* app = (NEMRAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [app managedObjectContext];
  }
  return self;
}

+ (instancetype) sharedStoreForEntity: (NSString*) entityName {
  static NSMutableDictionary* entityNameForStore;

  if (!entityNameForStore) {
    entityNameForStore = [[NSMutableDictionary alloc] init];
  }

  BaseStore* b = [entityNameForStore objectForKey:entityName];
  if (!b) {
    NSLog(@"Creating base store for %@", entityName);
    b = [[BaseStore alloc] initForEntityName:entityName];
    [entityNameForStore setObject:b forKey:entityName];
  }
  return b;
}

- (NSArray*) entities {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:self.entityName
                                       inManagedObjectContext:ctx];
  req.entity = e;
  NSError *error;
  NSArray* result = [ctx executeFetchRequest:req error:&error];
  if (!result) {
    [NSException raise:@"Fetch failed"
                format:@"Reason: %@", [error localizedDescription]];
  }
  NSLog(@"%@", result);
  return result;
}

- (NSManagedObject*) newEntity {
  NSManagedObjectContext* ctx = self.managedObjectContext;

  NSManagedObject* obj = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                       inManagedObjectContext:ctx];

  NSError* error;
  if (![ctx save:&error]) {
    [NSException raise:@"Save failed"
                format:@"Reason: %@", [error localizedDescription]];
  }

  return obj;
}

- (void)removeEntity:(NSManagedObject *)obj {
  [self.managedObjectContext deleteObject:obj];
  [self saveChanges];
}

- (void) saveChanges {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSError* error;
  if (![ctx save:&error]) {
    [NSException raise:@"Save failed" format:@"Reason: %@",[error localizedDescription]];
  }
}

@end
