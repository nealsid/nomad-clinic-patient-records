//
//  PatientVisitStore.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/29/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "PatientVisitStore.h"

#import "Clinician.h"
#import "ClinicianStore.h"
#import "NEMRAppDelegate.h"
#import "Patient.h"
#import "PatientStore.h"
#import "PatientVisit.h"
#import <CoreData/CoreData.h>

@interface PatientVisitStore ()

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

- (instancetype)init;

@end

@implementation PatientVisitStore

- (PatientVisit*) newPatientVisit {
  NSManagedObjectContext* ctx = self.managedObjectContext;

  PatientVisit* pv = [NSEntityDescription insertNewObjectForEntityForName:@"PatientVisit"
                                                   inManagedObjectContext:ctx];
  NSError* error;
  if (![ctx save:&error]) {
    [NSException raise:@"Save failed"
                format:@"Reason: %@", [error localizedDescription]];
  }

  return pv;
}

+ (instancetype) sharedPatientVisitStore {
  static PatientVisitStore* patientvisitStore;

  if (!patientvisitStore) {
    patientvisitStore = [[PatientVisitStore alloc] init];
  }
  return patientvisitStore;
}

- (instancetype) init {
  self = [super init];
  if (self) {
    NEMRAppDelegate* app = (NEMRAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [app managedObjectContext];
    [self createPatientVisitsIfNecessary];
  }
  return self;
}

- (void)removePatientVisit:(PatientVisit*)pv {
  [self.managedObjectContext deleteObject:pv];
  [self saveChanges];
}

- (void) saveChanges {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSError* error;
  if (![ctx save:&error]) {
    [NSException raise:@"Save failed" format:@"Reason: %@",[error localizedDescription]];
  }
}

- (NSArray*) patientVisitsForPatient:(Patient*)p {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"PatientVisit"
                                       inManagedObjectContext:ctx];
  NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"visit_date"
                                                       ascending:YES];
  req.sortDescriptors = @[sd];
  req.entity = e;

  if (p) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"patient == %@", p];
    req.predicate = predicate;
  }

  NSError *error;
  NSArray* result = [ctx executeFetchRequest:req error:&error];
  if (!result) {
    [NSException raise:@"Fetch failed"
                format:@"Reason: %@", [error localizedDescription]];
  }
  NSLog(@"%@", result);
  return result;
}

- (void)createPatientVisitsIfNecessary {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"PatientVisit"
                                       inManagedObjectContext:ctx];
  NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"visit_date"
                                                       ascending:YES];
  req.sortDescriptors = @[sd];
  req.entity = e;
  NSError *error;
  NSArray* result = [ctx executeFetchRequest:req error:&error];
  if (!result) {
    [NSException raise:@"Fetch failed" format:@"Reason: %@",[error localizedDescription]];
  }
  if ([result count] == 0) {
    NSLog(@"No PatientVisits found, generating..");
    PatientVisit* pv = [NSEntityDescription insertNewObjectForEntityForName:@"PatientVisit"
                                                     inManagedObjectContext:ctx];
    pv.visit_date = [NSDate date];
    if (![ctx save:&error]) {
      [NSException raise:@"Save failed" format:@"Reason: %@",[error localizedDescription]];
    }
  }
}

@end
