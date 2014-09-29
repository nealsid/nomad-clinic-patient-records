//
//  DiseaseChooserTableViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/16/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TableViewController.h"

@class VisitNotesComplex;
@protocol FieldEditDelegate;

@interface DiseaseChooserTableViewController : TableViewController

- (instancetype) initWithFieldMetadata:(NSDictionary*)fieldMetadata
                        fromVisitNotes:(VisitNotesComplex*)notes
                  fieldChangedDelegate:(id<FieldEditDelegate>) delegate;

@end
