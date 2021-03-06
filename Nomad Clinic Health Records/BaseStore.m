//
//  BaseStore.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/3/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "BaseStore.h"
#import "Clinic.h"
#import "Clinician.h"
#import "Disease.h"
#import "FlexDate.h"
#import "NEMRAppDelegate.h"
#import "Patient.h"
#import "Patient+Gender.h"
#import "Utils.h"
#import "Village.h"
#import "Visit.h"
#import "VisitNotesComplex.h"
#import "VisitNotesComplex+WeightClass.h"

@interface BaseStore ()

- (instancetype) initForEntityName:(NSString*)name;

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;

- (void) createTestDataIfNecessary;

@end

@implementation BaseStore

- (instancetype) initForEntityName:(NSString*)name {
  self = [super init];
  static bool testDataChecked = NO;
  if (self) {
    self.entityName = name;
    NEMRAppDelegate* app = (NEMRAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [app managedObjectContext];
    if (!testDataChecked) {
      [self createTestDataIfNecessary];
      testDataChecked = YES;
    }
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
  return [self entitiesWithSortKey:nil ascending:YES andPredicate:nil];
}

- (NSArray*) entitiesWithPredicate:(NSPredicate*)predicate {
  return [self entitiesWithSortKey:nil ascending:YES andPredicate:predicate];
}

- (NSArray*) entitiesWithSortKey:(NSString*) sortKey ascending:(BOOL)ascending {
  return [self entitiesWithSortKey:sortKey ascending:ascending andPredicate:nil];
}

- (NSArray*) entitiesWithSortKey:(NSString*) sortKey ascending:(BOOL)ascending andPredicate:(NSPredicate*) predicate {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:self.entityName
                                       inManagedObjectContext:ctx];
  req.entity = e;
  if (sortKey) {
    NSMutableArray* sortDescriptors = [NSMutableArray array];

    NSArray* components = [sortKey componentsSeparatedByString:@","];
    for (NSString* oneComponent in components) {
      NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:oneComponent
                                                           ascending:ascending];
      [sortDescriptors addObject:sd];
    }
    req.sortDescriptors = sortDescriptors;
  }

  if (predicate) {
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

- (NSManagedObject*) mostRecentRelatedEntity:(NSString*) relatedEntityName
                                 forInstance:(NSManagedObject*) mo
                              byRelationName:(NSString *) relationName
                                   dateField:(NSString*) dateField {
  NSArray* relatedEntities = [self relatedEntities:relatedEntityName
                                       forInstance:mo
                                      byRelationName:relationName
                                           sortKey:dateField];
  if (relatedEntities.count > 0) {
    Visit* v = [relatedEntities objectAtIndex:0];
    NSLog(@"Most recent related: %@", v);
    NSLog(@"Most recent related: %@", v.visit_date);

    return [relatedEntities objectAtIndex:0];
  }
  return nil;
}

- (NSArray*) relatedEntities:(NSString*) relatedEntityName
                 forInstance:(NSManagedObject*) mo
              byRelationName:(NSString*) relationName
                     sortKey:(NSString*) sortKey {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:relatedEntityName
                                       inManagedObjectContext:ctx];
  if (sortKey) {
    NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:sortKey
                                                       ascending:NO];
    req.sortDescriptors = @[sd];
  }

  req.entity = e;

  NSPredicate *predicate =
  [NSPredicate predicateWithFormat:@"%K == %@", relationName, mo];
  req.predicate = predicate;
  NSLog(@"Fetch: %@", req);
  NSError *error;
  NSArray* result = [ctx executeFetchRequest:req error:&error];
  if (!result) {
    [NSException raise:@"Fetch failed"
                format:@"Reason: %@", [error localizedDescription]];
  }
  NSLog(@"%ld results", (long)result.count);
  return result;
}

- (NSArray*) relatedEntities:(NSString*) relatedEntityName
                 forInstance:(NSManagedObject*) mo
              byRelationName:(NSString*)relationName {
  return [self relatedEntities:relatedEntityName
                   forInstance:mo
                byRelationName:relationName
                       sortKey:nil];
}

- (void) createTestDataIfNecessary {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"Clinic" inManagedObjectContext:ctx];
  req.entity = e;
  NSError *error;
  NSArray* result = [ctx executeFetchRequest:req error:&error];
  if (!result) {
    [NSException raise:@"Fetch failed" format:@"Reason: %@",[error localizedDescription]];
  }
  if ([result count] > 0) {
    return;
  }
  NSLog(@"No data found, generating..");

  NSArray* clinicNames = @[@"Ghami Raju Bista", @"Tsarang", @"Lo Monathang", @"Tang Ge"];
  NSArray* clinicDates = @[@"9/23/2014", @"9/25/2014", @"9/28/2014", @"10/04/2014"];
  NSDateFormatter* dateFormatter;
  dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateStyle = NSDateFormatterShortStyle;

  NSMutableArray* clinicObjects = [NSMutableArray array];
  for (int i = 0; i < clinicNames.count; ++i) {
    NSString* clinicName = clinicNames[i];

    Village* v = [NSEntityDescription insertNewObjectForEntityForName:@"Village"
                                               inManagedObjectContext:ctx];
    v.name = clinicName;
    Clinic* c = [NSEntityDescription insertNewObjectForEntityForName:@"Clinic"
                                              inManagedObjectContext:ctx];
    c.village = v;
    c.clinic_date = [dateFormatter dateFromString:clinicDates[i]];
    [clinicObjects addObject:c];
  }


//  NSArray* patientNames = @[@"Neal Sidhwaney",
//                            @"Bob Jones",
//                            @"Jane Doe",
//                            @"Isabel Bradley"];
//
//  NSArray* patientGenders = @[[NSNumber numberWithInteger:Male],
//                              [NSNumber numberWithInteger:Male],
//                              [NSNumber numberWithInteger:Female],
//                              [NSNumber numberWithInteger:Female]];
//  NSMutableArray* patients = [[NSMutableArray alloc] init];
//  for (int i = 0; i < [patientNames count]; ++i) {
//    Patient* p = [NSEntityDescription insertNewObjectForEntityForName:@"Patient"
//
//                                               inManagedObjectContext:ctx];
//    p.name = [patientNames objectAtIndex:i];
//    p.gender = [patientGenders objectAtIndex:i];
//    p.dob = [NSEntityDescription insertNewObjectForEntityForName:@"FlexDate" inManagedObjectContext:ctx];
//    [patients addObject:p];
//  }
//
//  for(int i = 0 ; i < 4 ; ++i) {
//    FlexDate* f = [[patients objectAtIndex:i] dob];
//    f.specificdate = [Utils dateFromMonth:3 day:8 year:(1941 + i)];
//  }
//
//
//  NSMutableArray* clinicians = [[NSMutableArray alloc] init];
//  NSArray* clinicianNames = @[@"Roshi Joan Halifax",
//                              @"Trudy Goldman",
//                              @"Kat Bogacz",
//                              @"Gary Pasternak",
//                              @"Sam Hughes"];
//  for (int i = 0; i < [clinicianNames count]; ++i) {
//    Clinician* c = [NSEntityDescription insertNewObjectForEntityForName:@"Clinician"
//                                                 inManagedObjectContext:ctx];
//    c.name = [clinicianNames objectAtIndex:i];
//    [clinicians addObject:c];
//  }
//
//  for (int i = 0; i < [patientNames count]; ++i) {
//    Visit* visit = [NSEntityDescription insertNewObjectForEntityForName:@"Visit"
//                                                 inManagedObjectContext:ctx];
//    visit.patient = [patients objectAtIndex:i];
//    visit.clinic = [clinicObjects objectAtIndex:(i % clinicObjects.count)];
//
//    visit.clinician = [NSSet setWithObject:[clinicians objectAtIndex:i]];
//    visit.visit_date = [Utils dateFromMonth:10 day:2 year:2013];
//    NSLog(@"Creating pv for %@ - %@", visit.patient.name, [[visit.clinician anyObject] name]);
//    VisitNotesComplex* visitNote =
//    [NSEntityDescription insertNewObjectForEntityForName:@"VisitNotesComplex"
//                                  inManagedObjectContext:ctx];
//    visitNote.visit = visit;
//    visitNote.note = @"This is test note #1";
//    visitNote.bp_systolic = @120;
//    visitNote.bp_diastolic = @80;
//    visitNote.healthy = [NSNumber numberWithBool:NO];
//    [visitNote setWeightClass:WeightClassExpected];
//    visitNote.breathing_rate = @60;
//    visitNote.pulse = @75;
//    visitNote.temp_fahrenheit = @98.6;
//    visitNote.subjective = @"This is the S in SOAP";
//    visitNote.objective = @"This is the O in SOAP";
//    visitNote.assessment = @"This is the A in SOAP";
//    visitNote.plan = @"This is the P in SOAP";
//  }

  NSArray* diseaseNames = @[@"Gastritis", @"Bronchitis", @"Osteoarthritis", @"Bursitis", @"Otitis media", @"Pneumonia"];
  for (NSString* oneDisease in diseaseNames) {
    Disease* d = [NSEntityDescription insertNewObjectForEntityForName:@"Disease"
                                               inManagedObjectContext:ctx];
    d.name = oneDisease;
  }

  if (![ctx save:&error]) {
    [NSException raise:@"Save failed" format:@"Reason: %@",[error localizedDescription]];
  }
}

- (NSArray*) patientsForClinic:(Clinic*) c {
  NSManagedObjectContext* ctx = self.managedObjectContext;
  NSFetchRequest* req = [[NSFetchRequest alloc] init];
  NSEntityDescription* e = [NSEntityDescription entityForName:@"Patient"
                                       inManagedObjectContext:ctx];
  NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                       ascending:YES];
  req.sortDescriptors = @[sd];
  req.entity = e;
  if (c) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(0 != SUBQUERY(visits, $x, $x.clinic == %@).@count)", c];
    req.predicate = predicate;
  }
  NSError *error;
  NSArray* result = [ctx executeFetchRequest:req error:&error];
  if (!result) {
    [NSException raise:@"Fetch failed"
                format:@"Reason: %@", [error localizedDescription]];
  }
  NSLog(@"Patient fetch had %lu results", (long)result.count);
  return result;
}

@end
