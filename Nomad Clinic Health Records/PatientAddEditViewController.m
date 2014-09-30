//
//  PatientAddEditViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/26/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PatientAddEditViewController.h"

#import "BaseStore.h"
#import "Clinic.h"
#import "FlexDate.h"
#import "FlexDate+ToString.h"
#import "Patient.h"
#import "Village.h"
#import "Visit.h"
#import "VisitNotesComplex.h"
#import "VisitNotesComplex+WeightClass.h"

@interface PatientAddEditViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSubviewYConstraint;
@property BOOL didAdjustForLayoutGuides;

@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITextField *patientAgeField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;
@property (weak, nonatomic) IBOutlet UIPickerView *villagePicker;

@property (strong, nonatomic) Patient* patient;
@property (weak, nonatomic) Village* village;
@property (weak, nonatomic) Clinic* clinic;

@property (weak, nonatomic) BaseStore* villageStore;
@property (strong, nonatomic) NSArray* allVillages;

@property (strong, nonatomic) IBOutlet UIToolbar *datePickerDone;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) NSDateFormatter* dateFormatter;
@property (strong, nonatomic) NSDate* patientBirthdate;
@end

@implementation PatientAddEditViewController

- (instancetype) initForNewPatientInVillage:(Village *) v atClinic:(Clinic*) c {
  return [self initWithNibName:nil
                        bundle:nil
                    forPatient:nil
                    andVillage:v
                      atClinic:c];
}

- (instancetype)initForPatient:(Patient *) p {
  return [self initWithNibName:nil
                        bundle:nil
                    forPatient:p
                    andVillage:p.village
                      atClinic:nil];
}

- (instancetype) initWithNibName:(NSString *) nibNameOrNil
                          bundle:(NSBundle *) bundleOrNil
                      forPatient:(Patient *) p
                       andVillage:(Village *) v
                        atClinic:(Clinic*) c {
  self = [super initWithNibName:nibNameOrNil bundle:bundleOrNil];
  if (self) {
    self.village = v;
    self.villageStore = [BaseStore sharedStoreForEntity:@"Village"];
    self.allVillages = [self.villageStore entities];
    self.patient = p;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    self.patientBirthdate = self.patient.dob.specificdate;
    self.clinic = c;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (self.village) {
    NSInteger index = [self.allVillages indexOfObject:self.village];
    [self.villagePicker selectRow:index inComponent:0 animated:YES];
  }
  if (self.patient) {
    self.patientNameField.text = self.patient.name;
    self.patientAgeField.text = [self.patient.dob toString];
    [self.genderControl setSelectedSegmentIndex:[self.patient.gender intValue]];
    if (self.patientBirthdate) {
      [self.datePicker setDate:self.patientBirthdate];
    }
  }
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                         target:self
                                                                                         action:@selector(saveChangesIfNecessary:)];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancel:)];
  self.patientAgeField.inputAccessoryView = self.datePickerDone;
  self.patientAgeField.inputView = self.datePicker;
}

- (IBAction)cancelEditing:(id)sender {
  [self.patientAgeField resignFirstResponder];
}

- (IBAction)doneEditing:(id)sender {
  self.patientAgeField.text = [self.dateFormatter stringFromDate:self.datePicker.date];
  self.patientBirthdate = self.datePicker.date;
  [self.patientAgeField resignFirstResponder];
}

- (void) cancel:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidLayoutSubviews {
  if (!self.didAdjustForLayoutGuides) {
    CGFloat topLayoutGuideLength = [self.topLayoutGuide length];
    self.topSubviewYConstraint.constant += topLayoutGuideLength;
    [self.view layoutSubviews];
    self.didAdjustForLayoutGuides = YES;
  }
}

- (void) saveChangesIfNecessary:(id)sender {
  NSString* newName = self.patientNameField.text;

  BOOL requiresSave = NO;
  if (!self.patient) {
    if ([newName length] > 0) {
      requiresSave = YES;
    }
  } else {
    if (![newName isEqualToString:self.patient.name]) {
      // Or if the user has modified the patient name.
      requiresSave = YES;
    }

    if (self.genderControl.selectedSegmentIndex != [self.patient.gender integerValue]) {
      requiresSave = YES;
    }

    NSLog(@"%@/%@", self.patientBirthdate, self.patient.dob.specificdate);
    if (![self.patientBirthdate isEqualToDate:self.patient.dob.specificdate]) {
      requiresSave = YES;
    }

    NSInteger selectedVillage = [self.villagePicker selectedRowInComponent:0];
    Village* v = [self.allVillages objectAtIndex:selectedVillage];
    if (self.patient.village != v) {
      requiresSave = YES;
    }
  }

  if (requiresSave) {
    NSLog(@"Requires save");
    if (!self.patient) {
      self.patient = (Patient*)[[BaseStore sharedStoreForEntity:@"Patient"] newEntity];
      self.patient.dob = (FlexDate*)[[BaseStore sharedStoreForEntity:@"FlexDate"] newEntity];
      Visit* v = (Visit*)[[BaseStore sharedStoreForEntity:@"Visit"] newEntity];
      VisitNotesComplex* notes = (VisitNotesComplex*)[[BaseStore sharedStoreForEntity:@"VisitNotesComplex"] newEntity];
      v.patient = self.patient;
      v.clinic = self.clinic;
      v.notes = notes;
      v.visit_date = [NSDate date];
      [v.notes setWeightClass:WeightClassExpected];
    }
    self.patient.name = newName;
    self.patient.gender = [NSNumber numberWithInteger:self.genderControl.selectedSegmentIndex];
    NSInteger selectedVillage = [self.villagePicker selectedRowInComponent:0];
    Village* v = [self.allVillages objectAtIndex:selectedVillage];
    self.patient.village = v;
    self.patient.dob.specificdate = self.patientBirthdate;
    [[BaseStore sharedStoreForEntity:@"Patient"] saveChanges];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) highlightInvalidUIElements {
  if ([self.patientNameField.text length] == 0) {
    self.patientNameField.layer.masksToBounds = YES;
    self.patientNameField.layer.borderColor = [[UIColor redColor] CGColor];
    self.patientNameField.layer.borderWidth = 1.0f;
  } else {
    self.patientNameField.layer.borderColor = [[UIColor clearColor] CGColor];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
  return self.allVillages.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  NSString* villageName = [[self.allVillages objectAtIndex:row] name];
  NSLog(@"Row %ld - %@", (long)row, villageName);
  return villageName;
}

@end
