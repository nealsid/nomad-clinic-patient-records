//
//  VisitNotesComplex+WeightClass.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/1/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "VisitNotesComplex+WeightClass.h"

#import "VisitNotesComplex.h"

@implementation VisitNotesComplex (WeightClass)

- (VisitWeightClass)weightClassForVisit {
  NSNumber* weightClassNumber = self.weight_class;
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassExtremelyLow]]) {
    return WeightClassExtremelyLow;
  }
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassLow]]) {
    return WeightClassLow;
  }
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassExpected]]) {
    return WeightClassExpected;
  }
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassHigh]]) {
    return WeightClassHigh;
  }
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassExtremelyHigh]]) {
    return WeightClassExtremelyHigh;
  }
  return WeightClassUnknown;
}

- (BOOL) isWeightExteme {
  VisitWeightClass visitWeightClass = [self weightClassForVisit];
  return visitWeightClass == WeightClassExtremelyLow || visitWeightClass == WeightClassExtremelyHigh;
}

+ (NSArray*)allWeightClassesAsStrings {
  NSMutableArray* weightClassStrings = [NSMutableArray array];
  for (int i = 0; i < WeightClassUnknown; ++i) {
    [weightClassStrings addObject:[VisitNotesComplex stringForWeightClass:[NSNumber numberWithInt:i]]];
  }
  return weightClassStrings;
}

+ (NSString*)shortStringForWeightClass:(NSNumber*) weightClassNumber {
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassExtremelyLow]]) {
    return @"--";
  }
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassLow]]) {
    return @"-";
  }
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassExpected]]) {
    return @"OK";
  }
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassHigh]]) {
    return @"+";
  }
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassExtremelyHigh]]) {
    return @"++";
  }
  return @"??";
}

+ (NSString*)stringForWeightClass:(NSNumber*) weightClassNumber {
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassExtremelyLow]]) {
    return @"Extremely Low";
  }
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassLow]]) {
    return @"Low";
  }
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassExpected]]) {
    return @"Expected";
  }
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassHigh]]) {
    return @"High";
  }
  if ([weightClassNumber isEqualToNumber:[NSNumber numberWithInteger:WeightClassExtremelyHigh]]) {
    return @"Extremely High";
  }
  return @"Unknown";
}

- (void)setWeightClass:(VisitWeightClass) weightClass {
  self.weight_class = [NSNumber numberWithInt:weightClass];
}

@end
