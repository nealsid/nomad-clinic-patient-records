//
//  Clinic.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/25/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient, Village;

@interface Clinic : NSManagedObject

@property (nonatomic, retain) NSDate * clinic_date;
@property (nonatomic, retain) Village *village;
@property (nonatomic, retain) Patient *patients;

@end
