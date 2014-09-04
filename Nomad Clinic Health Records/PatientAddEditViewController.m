//
//  PatientAddEditViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/26/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PatientAddEditViewController.h"

#import "FlexDate.h"
#import "FlexDate+ToString.h"
#import "Patient.h"
#import "PatientStore.h"
#import "Clinic.h"
#import "ClinicStore.h"
#import "Village.h"
#import "VisitStore.h"

@interface PatientAddEditViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSubviewYConstraint;
@property BOOL didAdjustForLayoutGuides;

@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITextField *patientAgeField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;
@property (weak, nonatomic) IBOutlet UIPickerView *clinicPicker;

@property (strong, nonatomic) Patient* patient;
@property (weak, nonatomic) Village* village;

@property (weak, nonatomic) ClinicStore* clinicStore;
@property (strong, nonatomic) NSArray* allClinics;

@property (strong, nonatomic) IBOutlet UIToolbar *datePickerDone;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) NSDateFormatter* dateFormatter;
@property (strong, nonatomic) NSDate* patientBirthdate;
@end

@implementation PatientAddEditViewController

- (instancetype) initForNewPatientInVillage:(Village *)v {
  return [self initWithNibName:nil
                        bundle:nil
                    forPatient:nil
                    andVillage:v];
}

- (instancetype)initForPatient:(Patient *) p {
  return [self initWithNibName:nil
                        bundle:nil
                    forPatient:p
                    andVillage:p.village];
}

- (instancetype) initWithNibName:(NSString *) nibNameOrNil
                          bundle:(NSBundle *) bundleOrNil
                      forPatient:(Patient *) p
                       andVillage:(Village *) v {
  self = [super initWithNibName:nibNameOrNil bundle:bundleOrNil];
  if (self) {
    self.village = v;
    self.clinicStore = [ClinicStore sharedClinicStore];
    self.allClinics = [self.clinicStore clinics];
    self.patient = p;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    self.patientBirthdate = self.patient.dob.specificdate;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (self.village) {
    NSInteger index = [self.allClinics indexOfObject:self.village];
    [self.clinicPicker selectRow:index inComponent:0 animated:YES];
  }
  if (self.patient) {
    self.patientNameField.text = self.patient.name;
    self.patientAgeField.text = [self.patient.dob toString];
    [self.genderControl setSelectedSegmentIndex:[self.patient.gender intValue]];
    [self.datePicker setDate:self.patientBirthdate];
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

    NSInteger selectedClinic = [self.clinicPicker selectedRowInComponent:0];
    Clinic* c = [self.allClinics objectAtIndex:selectedClinic];
    if (self.patient.clinic != c) {
      requiresSave = YES;
    }
  }

  if (requiresSave) {
    NSLog(@"Requires save");
    if (!self.patient) {
      self.patient = [[PatientStore sharedPatientStore] newPatient];
      [[VisitStore sharedVisitStore] newVisitForPatient:self.patient];
    }
    self.patient.name = newName;
    self.patient.gender = [NSNumber numberWithInteger:self.genderControl.selectedSegmentIndex];
    NSInteger selectedClinic = [self.clinicPicker selectedRowInComponent:0];
    Clinic* c = [self.allClinics objectAtIndex:selectedClinic];
    self.patient.clinic = c;
    self.patient.dob.specificdate = self.patientBirthdate;
    [[PatientStore sharedPatientStore] saveChanges];
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

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return self.allClinics.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  NSLog(@"Row %ld - %@", (long)row, [[[self.allClinics objectAtIndex:row] village] name]);
  return [[[self.allClinics objectAtIndex:row] village] name];
}

@end
