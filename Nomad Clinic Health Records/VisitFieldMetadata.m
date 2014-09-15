//
//  VisitFieldMetadata.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/14/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "VisitFieldMetadata.h"

#import "PatientViewController.h"

@implementation VisitFieldMetadata

static NSArray* visitFieldMetadata;

+ (NSArray*) visitFieldMetadata {
  if (!visitFieldMetadata) {
    visitFieldMetadata = @[@{@"fieldName":@"healthy",
                             @"prettyName":@"Is Healthy?",
                             @"defaultValue":[NSNumber numberWithBool:NO]},

                           @{@"fieldName":@"bp_systolic",
                             @"prettyName":@"Blood pressure",
                             @"formatSelector":[NSValue valueWithPointer:@selector(formatBloodPressure:)],
                             @"defaultValue":[NSNumber numberWithInt:0]},

                           @{@"fieldName":@"breathing_rate",
                             @"prettyName":@"Breathing rate",
                             @"defaultValue":[NSNumber numberWithInt:0]},

                           @{@"fieldName":@"pulse",
                             @"prettyName":@"Pulse",
                             @"defaultValue":[NSNumber numberWithInt:0]},

                           @{@"fieldName":@"temp_fahrenheit",
                             @"prettyName":@"Temp (℉)",
                             @"defaultValue":[NSNumber numberWithInt:0]},

                           @{@"fieldName":@"weight",
                             @"prettyName":@"Weight",
                             @"defaultValue":[NSNumber numberWithInt:0]},

                           @{@"fieldName":@"weight_class",
                             @"prettyName":@"Weight class",
                             @"formatSelector":[NSValue valueWithPointer:@selector(formatWeightClass:)],
                             @"defaultValue":[NSNumber numberWithInt:2]},

                           @{@"fieldName":@"subjective",
                             @"prettyName":@"Subjective",
                             @"defaultValue":@""},

                           @{@"fieldName":@"objective",
                             @"prettyName":@"Objective",
                             @"defaultValue":@""},

                           @{@"fieldName":@"assessment",
                             @"prettyName":@"Assessment",
                             @"defaultValue":@""},

                           @{@"fieldName":@"plan",
                             @"prettyName":@"Plan",
                             @"defaultValue":@""},

                           @{@"fieldName":@"note",
                             @"prettyName":@"Note",
                             @"defaultValue":@""}];

  }
  return visitFieldMetadata;
}
@end
