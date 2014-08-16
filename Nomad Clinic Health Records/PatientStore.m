//
//  PatientStore.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/21/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//


#import "PatientStore.h"

#import "Clinician.h"
#import "FlexDate.h"
#import "NEMRAppDelegate.h"
#import "Patient.h"
#import "Visit.h"
#import "VisitNotesComplex.h"
#import "Utils.h"

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PatientStore ()

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

- (void)createTestDataIfNecessary;
- (instancetype)init;

@end

@implementation PatientStore

- (Patient*) newPatient {
  NSManagedObjectContext* ctx = self.managedObjectContext;

  Patient* p = [NSEntityDescription insertNewObjectForEntityForName:@"Patient"
                                             inManagedObjectContext:ctx];
  p.dob = [NSEntityDescription insertNewObjectForEntityForName:@"FlexDate"
                                        inManagedObjectContext:ctx];
  NSError* error;
  if (![ctx save:&error]) {
    [NSException raise:@"Save failed"
                format:@"Reason: %@", [error localizedDescription]];
  }

  return p;
}

+ (instancetype) sharedPatientStore {
  static PatientStore* patientStore;

  if (!patientStore) {
    patientStore = [[PatientStore alloc] init];
  }
  return patientStore;
}

- (instancetype) init {
  self = [super init];
  if (self) {
    NEMRAppDelegate* app = (NEMRAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [app managedObjectContext];
    [self createTestDataIfNecessary];
  }
  return self;
}

- (void)removePatient:(Patient*)p {
  [self.managedObjectContext deleteObject:p];
  [self saveChanges];
}

- (void) saveChanges {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSError* error;
  if (![ctx save:&error]) {
    [NSException raise:@"Save failed" format:@"Reason: %@",[error localizedDescription]];
  }
}

- (NSArray*) patients {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"Patient"
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
  NSLog(@"%@", result);
  return result;
}

- (void) createTestDataIfNecessary {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext:ctx];
  NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  req.sortDescriptors = @[sd];
  req.entity = e;
  NSError *error;
  NSArray* result = [ctx executeFetchRequest:req error:&error];
  if (!result) {
    [NSException raise:@"Fetch failed" format:@"Reason: %@",[error localizedDescription]];
  }
  if ([result count] > 0) {
    return;
  }
  NSLog(@"No patients found, generating..");

  NSArray* patientNames = @[@"Neal Sidhwaney",
                            @"Bob Jones",
                            @"Jane Doe",
                            @"Isabel Bradley"];

  NSArray* patientGenders = @[@1, @1, @0, @0];
  NSMutableArray* patients = [[NSMutableArray alloc] init];
  for (int i = 0; i < [patientNames count]; ++i) {
    Patient* p = [NSEntityDescription insertNewObjectForEntityForName:@"Patient"
                  
                                               inManagedObjectContext:ctx];
    p.name = [patientNames objectAtIndex:i];
    p.gender = [patientGenders objectAtIndex:i];
    p.dob = [NSEntityDescription insertNewObjectForEntityForName:@"FlexDate" inManagedObjectContext:ctx];
    [patients addObject:p];
  }
  for(int i = 0 ; i < 2 ; ++i) {
    FlexDate* f = [[patients objectAtIndex:i] dob];
    f.year = @(1980 + i);
  }
  
  for(int i = 2 ; i < 4 ; ++i) {
    FlexDate* f = [[patients objectAtIndex:i] dob];
    f.specificdate = [Utils dateFromMonth:9 day:2 year:(1980 + i)];
  }
  

  NSMutableArray* clinicians = [[NSMutableArray alloc] init];
  NSArray* clinicianNames = @[@"Roshi Joan Halifax",
                              @"Trudy Goldman",
                              @"Kat Bogacz",
                              @"Gary Pasternak",
                              @"Sam Hughes"];
  for (int i = 0; i < [clinicianNames count]; ++i) {
    Clinician* c = [NSEntityDescription insertNewObjectForEntityForName:@"Clinician"
                                               inManagedObjectContext:ctx];
    c.name = [clinicianNames objectAtIndex:i];
    [clinicians addObject:c];
  }

  for (int i = 0; i < [patientNames count]; ++i) {
    Visit* visit = [NSEntityDescription insertNewObjectForEntityForName:@"Visit"
                                             inManagedObjectContext:ctx];
    visit.patient = [patients objectAtIndex:i];
    visit.clinician = [NSSet setWithObject:[clinicians objectAtIndex:i]];
    visit.visit_date = [Utils dateFromMonth:10 day:2 year:2013];
    NSLog(@"Creating pv for %@ - %@", visit.patient.name, [[visit.clinician anyObject] name]);
    VisitNotesComplex* visitNote =
    [NSEntityDescription insertNewObjectForEntityForName:@"VisitNotesComplex"
                                  inManagedObjectContext:ctx];
    visitNote.note = @"This is test note #1";
    visitNote.visit = visit;
    visitNote.bp_systolic = @120;
    visitNote.bp_diastolic = @80;
    visitNote.breathing_rate = @60;
    visitNote.pulse = @75;
    visitNote.temp_fahrenheit = @98.6;
    visitNote.subjective = @"This is the S in SOAP";
    visitNote.objective = @"This is the O in SOAP";
    visitNote.assessment = @"This is the A in SOAP";
    visitNote.plan = @"This is the P in SOAP";
  }

  if (![ctx save:&error]) {
    [NSException raise:@"Save failed" format:@"Reason: %@",[error localizedDescription]];
  }
}

@end
