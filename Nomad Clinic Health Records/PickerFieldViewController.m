//
//  PickerFieldViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/1/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PickerFieldViewController.h"

#import "FieldEditDelegate.h"
#import "VisitNotesComplex.h"
#import "VisitNotesComplex+WeightClass.h"

@interface PickerFieldViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSubviewYConstraint;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *fieldNameLabel;

@property (strong, nonatomic) NSArray* pickerChoices;
@property (strong, nonatomic) NSString* fieldName;
@property NSInteger initialChoice;
@property BOOL adjustedForTopLayout;
@property (strong, nonatomic) NSDictionary* fieldMetadata;

@property (strong, nonatomic) id<FieldEditDelegate> delegate;

@end

@implementation PickerFieldViewController

- (instancetype) initWithFieldMetadata:(NSDictionary*)fieldMetadata
                        fromVisitNotes:(VisitNotesComplex*)notes
                  fieldChangedDelegate:(id<FieldEditDelegate>) delegate {
  NSString* fieldName = [fieldMetadata objectForKey:@"fieldName"];
  NSArray* choices;
  NSInteger initialChoice;
  if ([fieldName isEqualToString:@"weight_class"]) {
    choices = [VisitNotesComplex allWeightClassesAsStrings];
    initialChoice = [notes.weight_class integerValue];
  }
  return [self initWithNibName:nil
                        bundle:nil
             visitFieldMetdata:fieldMetadata
                     fieldName:[fieldMetadata objectForKey:@"prettyName"]
                       choices:choices
            initialChoiceIndex:initialChoice
             fieldEditDelegate:delegate];
}

// - (instancetype) initWithFieldName:(NSString*)fieldName
//                            choices:(NSArray*)choices
//                 initialChoiceIndex:(NSInteger) initialChoice
//                  fieldEditDelegate:(id<FieldEditDelegate>)delegate {
//   return [self initWithNibName:nil
//                         bundle:nil
//                      fieldName:fieldName
//                        choices:choices
//             initialChoiceIndex:initialChoice
//                       fieldEditDelegate:delegate];
// }

- (instancetype)initWithNibName:(NSString *) nibNameOrNil
                         bundle:(NSBundle *) nibBundleOrNil
              visitFieldMetdata:(NSDictionary*)fieldMetadata
                      fieldName:(NSString*) fieldName
                        choices:(NSArray *) choices
             initialChoiceIndex:(NSInteger) initialChoice
              fieldEditDelegate:(id<FieldEditDelegate>) delegate {

  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self) {
    self.pickerChoices = choices;
    self.fieldName = fieldName;
    self.delegate = delegate;
    self.initialChoice = initialChoice;
    self.fieldMetadata = fieldMetadata;
  }
  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
  return [self initWithNibName:nibNameOrNil
                        bundle:nibBundleOrNil
             visitFieldMetdata:nil
                     fieldName:nil
                       choices:nil
            initialChoiceIndex:0
                      fieldEditDelegate:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.fieldNameLabel.text = self.fieldName;
  [self.pickerView selectRow:self.initialChoice inComponent:0 animated:YES];
  UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                              target:self
                                                                              action:@selector(saveField:)];
  [self.navigationItem setRightBarButtonItem:saveButton];
}

- (void) saveField:(id)sender {
  NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
  NSNumber* newValue = [NSNumber numberWithInteger:selectedRow];
  [self.delegate newFieldValuesFieldMetadata:self.fieldMetadata
                                      value1:newValue
                                      value2:nil];
}


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return self.pickerChoices.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  return [self.pickerChoices objectAtIndex:row];
}

- (void) viewDidLayoutSubviews {
  if (!self.adjustedForTopLayout) {
    CGFloat topLayoutGuideLength = [self.topLayoutGuide length];
    self.topSubviewYConstraint.constant += topLayoutGuideLength;
    [self.view layoutSubviews];
    self.adjustedForTopLayout = YES;
  }
}

@end
