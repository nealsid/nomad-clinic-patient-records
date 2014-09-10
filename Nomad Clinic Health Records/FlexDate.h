//
//  FlexDate.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/9/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;

@interface FlexDate : NSManagedObject

@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSDate * specificdate;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) Patient *patient;

@end
