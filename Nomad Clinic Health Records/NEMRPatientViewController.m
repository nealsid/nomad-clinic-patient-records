//
//  NEMRNewPatientViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "NEMRPatientViewController.h"
#import "Patient.h"
#import "PatientStore.h"

@interface NEMRPatientViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) Patient* patient;
@property (weak, nonatomic) id<NEMRPatientViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITextField *patientAgeField;
@property (weak, nonatomic) IBOutlet UIImageView *patientImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *patientPictureCamera;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation NEMRPatientViewController

- (IBAction)saveButtonAction:(id)sender {
  NSString* newName = self.patientNameField.text;

  NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
  [f setNumberStyle:NSNumberFormatterDecimalStyle];
  NSNumber * newAge = [f numberFromString:self.patientAgeField.text];
  BOOL requiresSave = NO;
  if (self.patient == nil) {
    Patient* p = [[PatientStore sharedPatientStore] newPatient];
    self.patient = p;
  }

  if ((self.patient.name == nil && [newName length] != 0) ||
      ![newName isEqualToString:self.patient.name]) {
    requiresSave = YES;
    self.patient.name = newName;
  }

  if ((self.patient.age == nil && [self.patientAgeField.text length] != 0) ||
      ![newAge isEqualToNumber:self.patient.age]) {
    requiresSave = YES;
    self.patient.age = newAge;
  }

  if (requiresSave) {
    [[PatientStore sharedPatientStore] saveChanges];
    [self.delegate patientViewControllerSave:self patient:self.patient];
  }
}

- (IBAction)cancelButtonAction:(id)sender {
  [self.delegate patientViewControllerCancel:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                     andPatient:(Patient*)p
                   withDelegate:(id<NEMRPatientViewControllerDelegate>)delegate {
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self) {
    self.patient = p;
    self.delegate = delegate;
  }

  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
  self = [self initWithNibName:nibNameOrNil
                        bundle:nibBundleOrNil
                    andPatient:nil
                  withDelegate:nil];
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (self.patient != nil) {
    [self.patientNameField setText:self.patient.name];
    [self.patientAgeField setText:[NSString stringWithFormat:@"%@",self.patient.age]];
  }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 80;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [NSString stringWithFormat:@"%lu",(long)row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}
@end
