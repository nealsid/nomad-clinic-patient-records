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
#import "Visit.h"
#import <CoreData/CoreData.h>

@interface PatientVisitStore ()

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

- (instancetype)init;

@end

@implementation PatientVisitStore

- (PatientVisit*) newPatientVisit {
  NSManagedObjectContext* ctx = self.managedObjectContext;

  PatientVisit* pv =
      [NSEntityDescription insertNewObjectForEntityForName:@"PatientVisit"
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

- (void)removePatientVisit:(Visit*)pv {
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
  if (!p) {
    return nil;
  }
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"PatientVisit"
                                       inManagedObjectContext:ctx];
  NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"visit_date"
                                                       ascending:YES];
  req.sortDescriptors = @[sd];
  req.entity = e;

  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"patient == %@", p];
  req.predicate = predicate;

  NSError *error;
  NSArray* result = [ctx executeFetchRequest:req error:&error];
  if (!result) {
    [NSException raise:@"Fetch failed"
                format:@"Reason: %@", [error localizedDescription]];
  }
  return result;
}

- (NSArray*) notesForPatientVisit:(PatientVisit*)pv {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"PatientVisitNotes"
                                       inManagedObjectContext:ctx];
  NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"note_date"
                                                       ascending:YES];
  req.sortDescriptors = @[sd];
  req.entity = e;

  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:@"patientVisit == %@", pv];
  req.predicate = predicate;

  NSError *error;
  NSArray* result = [ctx executeFetchRequest:req error:&error];
  if (!result) {
    [NSException raise:@"Fetch failed"
                format:@"Reason: %@", [error localizedDescription]];
  }
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
    Visit* visit = [NSEntityDescription insertNewObjectForEntityForName:@"PatientVisit"
                                                     inManagedObjectContext:ctx];
    visit.visit_date = [NSDate date];
    if (![ctx save:&error]) {
      [NSException raise:@"Save failed" format:@"Reason: %@",[error localizedDescription]];
    }
  }
}

@end
