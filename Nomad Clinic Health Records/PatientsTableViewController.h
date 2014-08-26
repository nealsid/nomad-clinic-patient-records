//
//  NEMRPatientsTableViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"

@class Clinic;

@interface PatientsTableViewController : TableViewController

/**
 * Designated initializer.  Returns a Patient Table View Controller initialized 
 * with the patients for the given clinic, or all patients if c is nil.
 *
 * @param c A Clinic or nil
 * @returns a PatientsTableViewController configured to display the relevant patients.
 */
 - (instancetype) initForClinic:(Clinic*) c;

@end
