//
//  Clinic.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/22/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Village;

@interface Clinic : NSManagedObject

@property (nonatomic, retain) Village *village;

@end
