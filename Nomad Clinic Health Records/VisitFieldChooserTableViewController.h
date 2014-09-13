//
//  VisitFieldChooserTableViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/13/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VisitNotesComplex;

@interface VisitFieldChooserTableViewController : UITableViewController

- (instancetype) initWithVisit:(VisitNotesComplex*) v;

@end
