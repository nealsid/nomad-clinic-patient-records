//
//  PatientVisitNoteViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/2/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PatientVisitNotes.h"

@interface PatientVisitNoteViewController : UIViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
                patientVisitNote:(PatientVisitNotes*)note;

@end
