//
//  VisitNotesComplex+WeightClass.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/1/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "VisitNotesComplex.h"

typedef NS_ENUM(NSInteger, VisitWeightClass) {
  WeightClassExtremelyLow,
  WeightClassLow,
  WeightClassExpected,
  WeightClassHigh,
  WeightClassExtremelyHigh,
  WeightClassUnknown
};

@interface VisitNotesComplex (WeightClass)

+ (NSString*)shortStringForWeightClass:(NSNumber*) weightClassNumber;
+ (NSString*)stringForWeightClass:(NSNumber*) weightClassNumber;
+ (NSArray*)allWeightClassesAsStrings;

- (BOOL) isWeightExteme;
- (VisitWeightClass)weightClassForVisit;
- (void)setWeightClass:(VisitWeightClass) weightClass;

@end
