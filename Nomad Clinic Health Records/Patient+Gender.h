//
//  Patient+Gender.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/19/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <Foundation/Foundation.h>

// An enum that represents gender options.  These HAVE to be kept in the same order as
// the UISegmentedControl for gender in PatientViewController.{xib,m,h}
typedef NS_ENUM(NSInteger, PatientGender) {
  Female,
  Male,
  Other
};

