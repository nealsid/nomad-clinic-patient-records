//
//  NEMRNewPatientViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

#import "NumberFieldViewController.h"
#import "SOAPViewController.h"

@interface PatientViewController : UIViewController <FieldEditDelegate, SOAPNoteViewControllerDelegate>

@property (strong, nonatomic) Visit* mostRecentVisit;
@property (strong, nonatomic) NSDateFormatter* dateFormatter;
@property (strong, nonatomic) UITableViewHeaderFooterView* sectionHeaderView;

/**
 * Designated initializer for the Patient view controller.
 *
 * @param andPatient The patient to edit or nil if a new patient
 * @param withDelegate The object that conforms to 
 *                     NEMRPatientViewControllerDelegate
 * @returns An initialized viewcontroller
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                     andPatient:(Patient*)p;

/**
 *  Method for the isHealthy switch in the Healthy row for a table visit.
 *  This method updates & commits the changes to CoreData.
 */
- (void) isHealthySwitchClicked:(id)sender;

@end
