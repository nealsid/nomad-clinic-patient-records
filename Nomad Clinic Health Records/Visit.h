//
//  Visit.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/16/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clinic, Clinician, Patient, VisitNotesComplex;

@interface Visit : NSManagedObject

@property (nonatomic, retain) NSDate * visit_date;
@property (nonatomic, retain) Clinic *clinic;
@property (nonatomic, retain) NSSet *clinician;
@property (nonatomic, retain) VisitNotesComplex *notes;
@property (nonatomic, retain) Patient *patient;
@end

@interface Visit (CoreDataGeneratedAccessors)

- (void)addClinicianObject:(Clinician *)value;
- (void)removeClinicianObject:(Clinician *)value;
- (void)addClinician:(NSSet *)values;
- (void)removeClinician:(NSSet *)values;

@end
