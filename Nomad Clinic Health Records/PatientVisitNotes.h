//
//  PatientVisitNotes.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/4/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Complaint, PatientVisit;

@interface PatientVisitNotes : NSManagedObject

@property (nonatomic, retain) NSNumber * bp_diastolic;
@property (nonatomic, retain) NSNumber * bp_systolic;
@property (nonatomic, retain) NSNumber * breathing_rate;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * note_date;
@property (nonatomic, retain) NSNumber * pulse;
@property (nonatomic, retain) NSNumber * temp_fahrenheit;
@property (nonatomic, retain) NSString * subjective;
@property (nonatomic, retain) NSString * objective;
@property (nonatomic, retain) NSString * assessment;
@property (nonatomic, retain) NSString * plan;
@property (nonatomic, retain) Complaint *chief_complaint;
@property (nonatomic, retain) PatientVisit *patientVisit;

@end
