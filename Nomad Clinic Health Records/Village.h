//
//  Village.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/9/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clinic, Patient;

@interface Village : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *held_clinics;
@property (nonatomic, retain) NSSet *patients;
@end

@interface Village (CoreDataGeneratedAccessors)

- (void)addHeld_clinicsObject:(Clinic *)value;
- (void)removeHeld_clinicsObject:(Clinic *)value;
- (void)addHeld_clinics:(NSSet *)values;
- (void)removeHeld_clinics:(NSSet *)values;

- (void)addPatientsObject:(Patient *)value;
- (void)removePatientsObject:(Patient *)value;
- (void)addPatients:(NSSet *)values;
- (void)removePatients:(NSSet *)values;

@end
