//
//  PickerFieldViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/1/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FieldEditDelegate;
@class VisitNotesComplex;

@interface PickerFieldViewController : UIViewController

/**
 * Initializes a PickerFieldViewController from field metadata.  Knows how
 * to construct a choice list from a given field (i.e. weight class)
 *
 * @param fieldMetadata The dictionary containing field information.
 * @param notes The visit notes.
 * @param delegate The delegate to call with the updated choice when
 * the user saves.
 */
- (instancetype) initWithFieldMetadata:(NSDictionary*)fieldMetadata
                        fromVisitNotes:(VisitNotesComplex*)notes
                  fieldChangedDelegate:(id<FieldEditDelegate>) delegate;

/**
 * Designated intializer.
 *
 * @param nibNameorNil Same as superclass.
 * @Param nibBundleOrNil Same as superclass.
 * @param choices The list of choices for the picker view.
 */
- (instancetype)initWithNibName:(NSString *) nibNameOrNil
                         bundle:(NSBundle *) nibBundleOrNil
              visitFieldMetdata:(NSDictionary*)fieldMetadata
                      fieldName:(NSString*) fieldName
                        choices:(NSArray *) choices
             initialChoiceIndex:(NSInteger) initialChoice
              fieldEditDelegate:(id<FieldEditDelegate>) delegate;

/**
 * Initializer to initialize the picker view with a list of choices.
 *
 * @param choices The list of choices.
 */
// - (instancetype) initWithFieldName:(NSString*) fieldName
//                            choices:(NSArray*) choices
//                 initialChoiceIndex:(NSInteger) initialChoice
//                  fieldEditDelegate:(id<FieldEditDelegate>) delegate;
@end
