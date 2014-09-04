//
//  ClinicStore.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/22/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "ClinicStore.h"
#import "NEMRAppDelegate.h"

@interface ClinicStore ()

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

@end

@implementation ClinicStore

+ (instancetype) sharedClinicStore {
  static ClinicStore* clinicStore;

  if (!clinicStore) {
    clinicStore = [[ClinicStore alloc] init];
  }
  return clinicStore;
}

- (instancetype) init {
  self = [super init];
  if (self) {
    NEMRAppDelegate* app = (NEMRAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [app managedObjectContext];
  }
  return self;
}

- (void)removeClinic:(Clinic*)c {
  [self.managedObjectContext deleteObject:c];
  [self saveChanges];
}

- (void) saveChanges {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSError* error;
  if (![ctx save:&error]) {
    [NSException raise:@"Save failed" format:@"Reason: %@",[error localizedDescription]];
  }
}

- (NSArray*) clinics {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"Clinic"
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

- (Clinic*) newClinic {
  NSManagedObjectContext* ctx = self.managedObjectContext;

  Clinic* c = [NSEntityDescription insertNewObjectForEntityForName:@"Clinic"
                                             inManagedObjectContext:ctx];

  NSError* error;
  if (![ctx save:&error]) {
    [NSException raise:@"Save failed"
                format:@"Reason: %@", [error localizedDescription]];
  }

  return c;
}

@end
