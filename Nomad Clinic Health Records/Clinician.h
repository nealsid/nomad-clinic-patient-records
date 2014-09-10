//
//  Clinician.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/9/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Visit;

@interface Clinician : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Visit *patient;

@end
