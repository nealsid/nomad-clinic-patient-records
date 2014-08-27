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

@interface PatientAddEditViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSubviewYConstraint;
@property BOOL didAdjustForLayoutGuides;

@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITextField *patientAgeField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;
@property (weak, nonatomic) IBOutlet UIPickerView *clinicPicker;

@property (weak, nonatomic) Patient* patient;
@property (weak, nonatomic) Clinic* clinic;

@property (weak, nonatomic) ClinicStore* clinicStore;
@property (strong, nonatomic) NSArray* allClinics;

@property (strong, nonatomic) UIBarButtonItem* oldBackButton;

@end

@implementation PatientAddEditViewController

- (instancetype) initForNewPatientAtClinic:(Clinic *)c {
  return [self initWithNibName:nil bundle:nil forPatient:nil andClinic:c];
}

- (instancetype)initForPatient:(Patient *)p {
  return [self initWithNibName:nil bundle:nil forPatient:p andClinic:nil];
}

- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil
                      forPatient:(Patient*)p andClinic:(Clinic*)c {
  self = [super initWithNibName:nibNameOrNil bundle:bundleOrNil];
  if (self) {
    self.clinic = c;
    self.clinicStore = [ClinicStore sharedClinicStore];
    self.allClinics = [self.clinicStore clinics];
    self.patient = p;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (self.clinic) {
    NSInteger index = [self.allClinics indexOfObject:self.clinic];
    [self.clinicPicker selectRow:index inComponent:0 animated:YES];
  }
  if (self.patient) {
    self.patientNameField.text = self.patient.name;
    self.patientAgeField.text = [self.patient.dob toString];
  }
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                         target:self
                                                                                         action:@selector(saveChangesIfNecessary:)];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancel:)];
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
  } else if (![newName isEqualToString:self.patient.name]) {
    // Or if the user has modified the patient name.
    requiresSave = YES;
  }

  if (requiresSave) {
    NSLog(@"Requires save");
    Patient* p = [[PatientStore sharedPatientStore] newPatient];
    self.patient = p;
    self.patient.name = newName;

    if (self.patient.dob == nil) {
      [NSException raise:@"Patient Save failed"
                  format:@"Reason: patient has no flex date"];
    }
    self.patient.gender = [NSNumber numberWithInteger:self.genderControl.selectedSegmentIndex];
    NSInteger selectedClinic = [self.clinicPicker selectedRowInComponent:0];
    Clinic* c = [self.allClinics objectAtIndex:selectedClinic];
    p.clinic = c;
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
