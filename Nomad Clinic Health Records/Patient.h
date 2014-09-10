//
//  Patient.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/9/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FlexDate, Village, Visit;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id picture;
@property (nonatomic, retain) FlexDate *dob;
@property (nonatomic, retain) Village *village;
@property (nonatomic, retain) NSSet *visits;
@end

@interface Patient (CoreDataGeneratedAccessors)

- (void)addVisitsObject:(Visit *)value;
- (void)removeVisitsObject:(Visit *)value;
- (void)addVisits:(NSSet *)values;
- (void)removeVisits:(NSSet *)values;

@end
