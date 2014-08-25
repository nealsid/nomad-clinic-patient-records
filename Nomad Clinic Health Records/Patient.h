//
//  Patient.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/25/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Clinic, FlexDate, Village, Visit;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id picture;
@property (nonatomic, retain) FlexDate *dob;
@property (nonatomic, retain) Village *village;
@property (nonatomic, retain) Visit *visits;
@property (nonatomic, retain) Clinic *clinic;

@end
