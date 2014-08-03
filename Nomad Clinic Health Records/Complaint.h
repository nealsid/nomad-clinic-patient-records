//
//  Complaint.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/2/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PatientVisitNotes;

@interface Complaint : NSManagedObject

@property (nonatomic, retain) NSString * complaint_description;
@property (nonatomic, retain) PatientVisitNotes *patients_with_complaint;

@end
