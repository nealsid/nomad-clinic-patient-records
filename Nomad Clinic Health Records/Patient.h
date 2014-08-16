//
//  Patient.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/11/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FlexDate, Visit;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id picture;
@property (nonatomic, retain) Visit *visits;
@property (nonatomic, retain) FlexDate *dob;

@end
