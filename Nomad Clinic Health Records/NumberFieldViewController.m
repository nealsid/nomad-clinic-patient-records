//
//  NumberFieldViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/18/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "NumberFieldViewController.h"

#import "VisitNotesComplex.h"

@interface NumberFieldViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueField;

@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITextField *field2;

@property (weak, nonatomic) id<FieldEditDelegate> delegate;
@property (strong, nonatomic) NSDictionary* visitFieldMetadata;
@property (strong, nonatomic) NSString* fieldName;
@property (strong, nonatomic) NSString* initialValue;

@property (strong, nonatomic) NSString* field2Name;
@property (strong, nonatomic) NSString* field2InitialValue;

@end

@implementation NumberFieldViewController

- (instancetype) initWithFieldMetadata:(NSDictionary*)fieldMetadata
                        fromVisitNotes:(VisitNotesComplex*)notes
                  fieldChangedDelegate:(id<FieldEditDelegate>) delegate {
  NSString* labelText = [fieldMetadata objectForKey:@"prettyName"];
  NSString *initialValue = [NSString stringWithFormat:@"%@", [notes valueForKey:[fieldMetadata objectForKey:@"fieldName"]]];
  NSString* diastolicLabel;
  NSString* initialDiastolic;
  // Special case blood pressure.
  if ([[fieldMetadata objectForKey:@"fieldName"] isEqualToString:@"bp_systolic"]) {
    labelText = @"Systolic";
    diastolicLabel = @"Diastolic";
    initialDiastolic = [NSString stringWithFormat:@"%@", [notes valueForKey:@"bp_diastolic"]];
  }
  return [self initWithNibName:nil
                        bundle:nil
                   visitFieldMetadata:(NSDictionary*)fieldMetadata
                     fieldName:labelText
                  initialValue:initialValue
                    field2Name:diastolicLabel
            field2InitialValue:initialDiastolic
          fieldChangedDelegate:delegate];
}

- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil
              visitFieldMetadata:(NSDictionary*)visitFieldMetadata
                       fieldName:(NSString*)fieldName
                    initialValue:(NSString*)initialValue
                      field2Name:(NSString*)field2Name
              field2InitialValue:(NSString*)field2InitialValue
            fieldChangedDelegate:(id<FieldEditDelegate>)delegate {
  self = [super initWithNibName:nibNameOrNil bundle:bundleOrNil];
  if(self) {
    self.fieldName = fieldName;
    self.initialValue = initialValue;
    self.field2Name = field2Name;
    self.field2InitialValue = field2InitialValue;
    self.visitFieldMetadata = visitFieldMetadata;
    self.delegate = delegate;
  }
  return self;
}

- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil {
  self = [self initWithNibName:nibNameOrNil
                        bundle:bundleOrNil
            visitFieldMetadata:nil
                     fieldName:@""
                  initialValue:@""
                    field2Name:nil
            field2InitialValue:nil
                      fieldChangedDelegate:nil];
  return self;
}

- (void)viewDidLoad {
  self.titleLabel.text = self.fieldName;
  self.valueField.text = self.initialValue;
  UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                              target:self
                                                                              action:@selector(saveField:)];
  [self.navigationItem setRightBarButtonItem:saveButton];
  if (self.field2Name) {
    self.label2.hidden = NO;
    self.field2.hidden = NO;
    self.label2.text = self.field2Name;
    self.field2.text = self.field2InitialValue;
  }
}

/* Returns YES if either field is invalid */
- (BOOL) highlightFieldsIfInvalid {
  BOOL field1IsValid = [self fieldIsValid:self.valueField];
  if (!field1IsValid) {
    self.valueField.layer.borderColor = [[UIColor redColor] CGColor];
    self.valueField.layer.borderWidth = 1.0f;
  } else {
    self.valueField.layer.borderColor = [[UIColor clearColor] CGColor];
    self.valueField.layer.borderWidth = 1.0f;
  }
  BOOL field2IsValid = self.field2Name && [self fieldIsValid:self.field2];

  if (!field2IsValid) {
    self.field2.layer.borderColor = [[UIColor redColor] CGColor];
    self.field2.layer.borderWidth = 1.0f;
  } else {
    self.field2.layer.borderColor = [[UIColor clearColor] CGColor];
    self.field2.layer.borderWidth = 1.0f;
  }
  return !field1IsValid || !field2IsValid;
}

- (BOOL) fieldIsValid:(UITextField*)textField {
  NSCharacterSet* ws = [NSCharacterSet whitespaceCharacterSet];
  if ([textField.text integerValue] == 0 &&
      ![[textField.text stringByTrimmingCharactersInSet:ws] isEqualToString:@"0"]) {
    return NO;
  }
  return YES;
}

- (void) saveField:(id)sender {
  if ([self highlightFieldsIfInvalid]) {
    return;
  }
  
  NSCharacterSet* ws = [NSCharacterSet whitespaceCharacterSet];
  NSString* input = [self.valueField.text stringByTrimmingCharactersInSet:ws];

  NSNumber* newValue = [NSNumber numberWithInteger:[input integerValue]];

  NSNumber* newValue2;
  if (self.field2Name) {
    NSString* input = [self.field2.text stringByTrimmingCharactersInSet:ws];
    newValue2 = [NSNumber numberWithInteger:[input integerValue]];
  }
  
  [self.delegate newFieldValuesFieldMetadata:self.visitFieldMetadata
                                      value1:newValue
                                      value2:newValue2];
}

@end
