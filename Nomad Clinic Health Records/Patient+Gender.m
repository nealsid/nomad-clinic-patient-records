//
//  Patient+Gender.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/27/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "Patient+Gender.h"

#import "Patient.h"

@implementation Patient (Gender)

- (BOOL) isFemale {
  return [self.gender isEqualToNumber:[NSNumber numberWithInteger:Female]];
}

- (BOOL) isMale {
  return [self.gender isEqualToNumber:[NSNumber numberWithInteger:Male]];
}

@end
