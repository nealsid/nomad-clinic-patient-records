//
//  PatientVisit.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/29/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clinician, Patient;

@interface PatientVisit : NSManagedObject

@property (nonatomic, retain) NSDate * visit_date;
@property (nonatomic, retain) Patient *patient;
@property (nonatomic, retain) NSSet *clinician;

@end

@interface PatientVisit (CoreDataGeneratedAccessors)

- (void)addClinicianObject:(Clinician *)value;
- (void)removeClinicianObject:(Clinician *)value;
- (void)addClinician:(NSSet *)values;
- (void)removeClinician:(NSSet *)values;

@end
