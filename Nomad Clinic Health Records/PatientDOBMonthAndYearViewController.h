//
//  PatientDOBMonthAndYearViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/12/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "AgeEntryChoiceViewController.h"

#import <UIKit/UIKit.h>

@interface PatientDOBMonthAndYearViewController : UIViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
               ageChosenDelegate:(id<AgeChosenDelegate>)delegate;

@end
