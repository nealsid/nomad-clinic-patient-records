//
//  SOAPViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/4/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FieldEditDelegate;
@class VisitNotesComplex;

@interface TextViewViewController : UIViewController

- (instancetype) initWithFieldMetadata:(NSDictionary*)fieldMetadata
                        fromVisitNotes:(VisitNotesComplex*)notes
                  fieldChangedDelegate:(id<FieldEditDelegate>) delegate;

- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil
              visitFieldMetadata:(NSDictionary*)visitFieldMetadata
                       fieldName:(NSString*)fieldName
                    initialValue:(NSString*)initialValue
            fieldChangedDelegate:(id<FieldEditDelegate>)delegate;

@end
