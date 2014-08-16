//
//  PatientVisitViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/29/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Visit.h"

@interface PatientVisitViewController : UIViewController

/**
 * Designated initializer for this view controller.
 *
 * @param nibNameOrNil Same as superclass
 * @param nibBunbldeOrNil Same as superclass
 * @param patientVisit the patientVisit to display in the view.
 * @returns An initialized view controller or nil if an error occurred.
 */
- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
                    patientVisit:(Visit*)visit;
@end
