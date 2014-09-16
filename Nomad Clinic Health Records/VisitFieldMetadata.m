//
//  VisitFieldMetadata.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/14/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "VisitFieldMetadata.h"

#import "PatientViewController.h"
#import "PickerFieldViewController.h"
#import "StringFieldViewController.h"

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
                             @"defaultValue":[NSNumber numberWithInt:0],
                             @"editClass":[NumberFieldViewController class]},

                           @{@"fieldName":@"breathing_rate",
                             @"prettyName":@"Breathing rate",
                             @"defaultValue":[NSNumber numberWithInt:0],
                             @"editClass":[NumberFieldViewController class]},

                           @{@"fieldName":@"pulse",
                             @"prettyName":@"Pulse",
                             @"defaultValue":[NSNumber numberWithInt:0],
                             @"editClass":[NumberFieldViewController class]},

                           @{@"fieldName":@"temp_fahrenheit",
                             @"prettyName":@"Temp (℉)",
                             @"defaultValue":[NSNumber numberWithInt:0],
                             @"editClass":[NumberFieldViewController class]},

                           @{@"fieldName":@"weight",
                             @"prettyName":@"Weight (lbs)",
                             @"defaultValue":[NSNumber numberWithInt:0],
                             @"editClass":[NumberFieldViewController class]},

                           @{@"fieldName":@"weight_class",
                             @"prettyName":@"Weight class",
                             @"formatSelector":[NSValue valueWithPointer:@selector(formatWeightClass:)],
                             @"defaultValue":[NSNumber numberWithInt:2],
                             @"editClass":[PickerFieldViewController class]},

                           @{@"fieldName":@"subjective",
                             @"prettyName":@"Subjective",
                             @"defaultValue":@"",
                             @"editClass":[StringFieldViewController class]},

                           @{@"fieldName":@"objective",
                             @"prettyName":@"Objective",
                             @"defaultValue":@"",
                             @"editClass":[StringFieldViewController class]},

                           @{@"fieldName":@"assessment",
                             @"prettyName":@"Assessment",
                             @"defaultValue":@"",
                             @"editClass":[StringFieldViewController class]},

                           @{@"fieldName":@"plan",
                             @"prettyName":@"Plan",
                             @"defaultValue":@"",
                             @"editClass":[StringFieldViewController class]},

                           @{@"fieldName":@"note",
                             @"prettyName":@"Note",
                             @"defaultValue":@"",
                             @"editClass":[StringFieldViewController class]}];

  }
  return visitFieldMetadata;
}
@end
