//
//  PatientAddEditViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/26/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PatientAddEditViewController.h"

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
@property (weak, nonatomic) NSArray* allClinics;


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
}

- (void) viewDidLayoutSubviews {
  if (!self.didAdjustForLayoutGuides) {
    CGFloat topLayoutGuideLength = [self.topLayoutGuide length];
    self.topSubviewYConstraint.constant += topLayoutGuideLength;
    [self.view layoutSubviews];
    self.didAdjustForLayoutGuides = YES;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
