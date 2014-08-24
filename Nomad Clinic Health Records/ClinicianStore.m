//
//  ClinicianStore.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/21/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//


#import "ClinicianStore.h"

#import "Clinician.h"
#import <CoreData/CoreData.h>
#import "NEMRAppDelegate.h"

@interface ClinicianStore ()

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

- (void)createCliniciansIfNecessary;
- (instancetype)init;

@end

@implementation ClinicianStore

- (Clinician*) newClinician {
  NSManagedObjectContext* ctx = self.managedObjectContext;

  Clinician* c = [NSEntityDescription insertNewObjectForEntityForName:@"Clinician"
                                             inManagedObjectContext:ctx];
  NSError* error;
  if (![ctx save:&error]) {
    [NSException raise:@"Save failed"
                format:@"Reason: %@", [error localizedDescription]];
  }

  return c;
}

+ (instancetype) sharedClinicianStore {
  static ClinicianStore* clinicianStore;

  if (!clinicianStore) {
    clinicianStore = [[ClinicianStore alloc] init];
  }
  return clinicianStore;
}

- (instancetype) init {
  self = [super init];
  if (self) {
    NEMRAppDelegate* app = (NEMRAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [app managedObjectContext];
    [self createCliniciansIfNecessary];
  }
  return self;
}

- (void)removeClinician:(Clinician*)c {
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

- (NSArray*) clinicians {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"Clinician"
                                       inManagedObjectContext:ctx];
  NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                       ascending:YES];
  req.sortDescriptors = @[sd];
  req.entity = e;
  NSError *error;
  NSArray* result = [ctx executeFetchRequest:req error:&error];
  if (!result) {
    [NSException raise:@"Fetch failed"
                format:@"Reason: %@", [error localizedDescription]];
  }
  return result;
}

- (void)createCliniciansIfNecessary {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"Clinician"
                                       inManagedObjectContext:ctx];
  NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                       ascending:YES];
  req.sortDescriptors = @[sd];
  req.entity = e;
  NSError *error;
  NSArray* result = [ctx executeFetchRequest:req error:&error];
  if (!result) {
    [NSException raise:@"Fetch failed" format:@"Reason: %@",[error localizedDescription]];
  }
  if ([result count] == 0) {
    NSLog(@"No Clinicians found, generating..");
    Clinician* c = [NSEntityDescription insertNewObjectForEntityForName:@"Clinician"
                                                 inManagedObjectContext:ctx];
    c.name = @"Neal Sidhwaney";
    if (![ctx save:&error]) {
      [NSException raise:@"Save failed" format:@"Reason: %@",[error localizedDescription]];
    }
  }
}

@end
