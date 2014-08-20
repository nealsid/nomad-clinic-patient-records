//
//  VisitStore.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/29/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "VisitStore.h"

#import "NEMRAppDelegate.h"
#import "Patient.h"
#import "PatientStore.h"
#import "Visit.h"
#import "VisitNotesComplex.h"

#import <CoreData/CoreData.h>

@interface VisitStore ()

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

- (instancetype)init;

@end

@implementation VisitStore

- (Visit*) newVisitForPatient:(Patient*) p {
  NSManagedObjectContext* ctx = self.managedObjectContext;

  Visit* pv =
      [NSEntityDescription insertNewObjectForEntityForName:@"Visit"
                                    inManagedObjectContext:ctx];

  pv.patient = p;
  pv.visit_date = [NSDate date];
  VisitNotesComplex* note = [NSEntityDescription insertNewObjectForEntityForName:@"VisitNotesComplex"
                                                          inManagedObjectContext:ctx];
  pv.notes = note;
  note.visit = pv;
  NSError* error;
  if (![ctx save:&error]) {
    [NSException raise:@"Save failed"
                format:@"Reason: %@", [error localizedDescription]];
  }

  return pv;
}

+ (instancetype) sharedVisitStore {
  static VisitStore* visitStore;

  if (!visitStore) {
    visitStore = [[VisitStore alloc] init];
  }
  return visitStore;
}

- (Visit*) mostRecentVisitForPatient:(Patient*)p {
  NSArray* visits = [self visitsForPatient:p];
  if (visits.count > 0) {
    return [visits objectAtIndex:0];
  }
  return nil;
}

- (instancetype) init {
  self = [super init];
  if (self) {
    NEMRAppDelegate* app = (NEMRAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [app managedObjectContext];
    [self createVisitsIfNecessary];
  }
  return self;
}

- (void)removeVisit:(Visit*)pv {
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

- (NSArray*) visitsForPatient:(Patient*)p {
  if (!p) {
    return nil;
  }
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"Visit"
                                       inManagedObjectContext:ctx];
  NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"visit_date"
                                                       ascending:NO];
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

- (NSArray*) notesForVisit:(Visit*)pv {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"VisitNotesComplex"
                                       inManagedObjectContext:ctx];
  NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"note_date"
                                                       ascending:YES];
  req.sortDescriptors = @[sd];
  req.entity = e;

  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:@"Visit == %@", pv];
  req.predicate = predicate;

  NSError *error;
  NSArray* result = [ctx executeFetchRequest:req error:&error];
  if (!result) {
    [NSException raise:@"Fetch failed"
                format:@"Reason: %@", [error localizedDescription]];
  }
  return result;
}

- (void)createVisitsIfNecessary {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"Visit"
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
    NSLog(@"No Visits found, generating..");
    Visit* visit = [NSEntityDescription insertNewObjectForEntityForName:@"Visit"
                                                     inManagedObjectContext:ctx];
    visit.visit_date = [NSDate date];
    if (![ctx save:&error]) {
      [NSException raise:@"Save failed" format:@"Reason: %@",[error localizedDescription]];
    }
  }
}

@end
