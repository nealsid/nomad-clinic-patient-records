//
//  Disease.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/16/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VisitNotesComplex;

@interface Disease : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *visitnotes;
@end

@interface Disease (CoreDataGeneratedAccessors)

- (void)addVisitnotesObject:(VisitNotesComplex *)value;
- (void)removeVisitnotesObject:(VisitNotesComplex *)value;
- (void)addVisitnotes:(NSSet *)values;
- (void)removeVisitnotes:(NSSet *)values;

@end
