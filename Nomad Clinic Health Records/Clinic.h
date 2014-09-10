//
//  Clinic.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/9/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Village, Visit;

@interface Clinic : NSManagedObject

@property (nonatomic, retain) NSDate * clinic_date;
@property (nonatomic, retain) Village *village;
@property (nonatomic, retain) Visit *visits;

@end
