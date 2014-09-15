//
//  NumberFieldViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/18/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldEditDelegate.h"

@class VisitNotesComplex;

@interface NumberFieldViewController : UIViewController

- (instancetype) initWithFieldMetadata:(NSDictionary*)fieldMetadata
                        fromVisitNotes:(VisitNotesComplex*)notes
                  fieldChangedDelegate:(id<FieldEditDelegate>) delegate;


- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil
              visitFieldMetadata:(NSDictionary*)visitFieldMetadata
                       fieldName:(NSString*)fieldName
                    initialValue:(NSString*)initialValue
                      field2Name:(NSString*)field2Name
              field2InitialValue:(NSString*)field2InitialValue
            fieldChangedDelegate:(id<FieldEditDelegate>)delegate;

@end
