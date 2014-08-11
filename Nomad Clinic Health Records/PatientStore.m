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
#import "Patient.h"
#import "PatientVisit.h"
#import "PatientVisitNotes.h"
#import "NEMRAppDelegate.h"

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PatientStore ()

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

- (void)createTestDataIfNecessary;
- (instancetype)init;
- (NSDate*)dateFromMonth:(NSInteger)month
                     day:(NSInteger)day
                    year:(NSInteger)year;

@end

@implementation PatientStore

- (Patient*) newPatient {
  NSManagedObjectContext* ctx = self.managedObjectContext;

  Patient* p = [NSEntityDescription insertNewObjectForEntityForName:@"Patient"
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
                            @""];
  NSMutableArray* flexDates = [NSMutableArray array];
  for(int i = 0 ; i < 2 ; ++i) {
    FlexDate* f = [NSEntityDescription insertNewObjectForEntityForName:@"FlexDate"
                                                inManagedObjectContext:ctx];
    f.minimum_year = @(1980 + i);
    f.maximum_year = @(1981 + i);
    [flexDates addObject:f];
  }
  for(int i = 0 ; i < 3 ; ++i) {
    FlexDate* f = [NSEntityDescription insertNewObjectForEntityForName:@"FlexDate"
                                                inManagedObjectContext:ctx];
    f.specificdate = [self dateFromMonth:9 day:2 year:(1980 + i)];
    [flexDates addObject:f];
  }

  NSArray* patientGenders = @[@1, @1, @0, @0];
  NSMutableArray* patients = [[NSMutableArray alloc] init];
  for (int i = 0; i < [patientNames count]; ++i) {
    Patient* p = [NSEntityDescription insertNewObjectForEntityForName:@"Patient"
                                               inManagedObjectContext:ctx];
    p.name = [patientNames objectAtIndex:i];
    p.gender = [patientGenders objectAtIndex:i];
    p.dob = [flexDates objectAtIndex:i];
    [patients addObject:p];
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
    PatientVisit* pv = [NSEntityDescription insertNewObjectForEntityForName:@"PatientVisit"
                                                     inManagedObjectContext:ctx];
    pv.patient = [patients objectAtIndex:i];
    pv.clinician = [NSSet setWithObject:[clinicians objectAtIndex:i]];
    pv.visit_date = [NSDate date];
    NSLog(@"Creating pv for %@ - %@", pv.patient.name, [[pv.clinician anyObject] name]);
    PatientVisitNotes* pvnote =
    [NSEntityDescription insertNewObjectForEntityForName:@"PatientVisitNotes"
                                  inManagedObjectContext:ctx];
    pvnote.note = @"This is test note #1";
    pvnote.patientVisit = pv;
    pvnote.note_date = [self dateFromMonth:10 day:2 year:2013];
    pvnote.bp_systolic = @120;
    pvnote.bp_diastolic = @80;
    pvnote.breathing_rate = @60;
    pvnote.pulse = @75;
    pvnote.temp_fahrenheit = @98.6;
    pvnote.subjective = @"This is the S in SOAP";
    pvnote.objective = @"This is the O in SOAP";
    pvnote.assessment = @"This is the A in SOAP";
    pvnote.plan = @"This is the P in SOAP";

    pvnote =
    [NSEntityDescription insertNewObjectForEntityForName:@"PatientVisitNotes"
                                  inManagedObjectContext:ctx];
    pvnote.note = @"This is test note #2";
    pvnote.patientVisit = pv;
    pvnote.note_date = [self dateFromMonth:10 day:2 year:2013];
    pvnote.bp_systolic = @130;
    pvnote.bp_diastolic = @100;
    pvnote.breathing_rate = @70;
    pvnote.pulse = @90;
    pvnote.temp_fahrenheit = @102.6;
    pvnote.subjective = @"This is the S in SOAP";
    pvnote.objective = @"This is the O in SOAP";
    pvnote.assessment = @"This is the A in SOAP";
    pvnote.plan = @"This is the P in SOAP";
  }

  if (![ctx save:&error]) {
    [NSException raise:@"Save failed" format:@"Reason: %@",[error localizedDescription]];
  }
}

- (NSDate*)dateFromMonth:(NSInteger)month day:(NSInteger)day year:(NSInteger)year {
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  [comps setDay:day];
  [comps setMonth:month];
  [comps setYear:year];
  NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDate *date = [cal dateFromComponents:comps];
  return date;
}

@end
