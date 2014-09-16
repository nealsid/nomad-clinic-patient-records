//
//  SOAPViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/4/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>

// An enum that represents which of the 4 components of a SOAP
// note we are displaying.  Used for UI purposes (header, etc).
// typedef NS_ENUM(NSInteger, SOAPEntryType) {
//   S,   // Subjective
//   O,   // Objective
//   A,   // Assessment
//   P    // Plan
// };

// @class SOAPViewController;

@protocol FieldEditDelegate;
@class VisitNotesComplex;

// - (void) soapViewController:(SOAPViewController*)vc saveNewNote:(NSString*)s
//                     forType:(SOAPEntryType)type;

// @end

@interface StringFieldViewController : UIViewController

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
