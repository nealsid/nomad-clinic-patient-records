//
//  VisitNotesComplex.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/16/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Disease, Visit;

@interface VisitNotesComplex : NSManagedObject

@property (nonatomic, retain) NSString * assessment;
@property (nonatomic, retain) NSNumber * bp_diastolic;
@property (nonatomic, retain) NSNumber * bp_systolic;
@property (nonatomic, retain) NSNumber * breathing_rate;
@property (nonatomic, retain) NSNumber * healthy;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * objective;
@property (nonatomic, retain) NSString * plan;
@property (nonatomic, retain) NSNumber * pulse;
@property (nonatomic, retain) NSString * subjective;
@property (nonatomic, retain) NSNumber * temp_fahrenheit;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * weight_class;
@property (nonatomic, retain) Visit *visit;
@property (nonatomic, retain) NSSet *diagnoses;
@end

@interface VisitNotesComplex (CoreDataGeneratedAccessors)

- (void)addDiagnosesObject:(Disease *)value;
- (void)removeDiagnosesObject:(Disease *)value;
- (void)addDiagnoses:(NSSet *)values;
- (void)removeDiagnoses:(NSSet *)values;

@end
