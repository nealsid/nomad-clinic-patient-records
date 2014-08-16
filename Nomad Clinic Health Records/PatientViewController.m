//
//  NEMRNewPatientViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "AgeEntryChoiceViewController.h"
#import "FlexDate.h"
#import "FlexDate+ToString.h"
#import "PatientViewController.h"
#import "Patient.h"
#import "PatientStore.h"
#import "VisitStore.h"
#import "PatientVisitViewController.h"
#import "Utils.h"

#import <QuartzCore/QuartzCore.h>

@interface PatientViewController () <AgeChosenDelegate>

@property (nonatomic, retain) Patient* patient;

@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITextField *patientAgeField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;

@property (weak, nonatomic) VisitStore* patientVisitStore;

@property (strong, nonatomic) NSDate* chosenDate;
@property NSNumber* chosenYear;
@property NSNumber* chosenMonth;
@property BOOL ageSet;

- (void) updateTitleFromPatientNameField;

@end

@implementation PatientViewController

- (void)ageWasChosenByBirthdate:(NSDate *)birthDate {
  self.chosenDate = birthDate;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateStyle = NSDateFormatterMediumStyle;
  formatter.timeStyle = NSDateFormatterNoStyle;
  [self.ageButton setTitle:[formatter stringFromDate:birthDate]
                  forState:UIControlStateNormal];
  self.ageSet = YES;
  [self.navigationController popToViewController:self animated:YES];
}

- (void) ageWasChosenByMonthAndOrYear:(NSInteger)year
                             andMonth:(NSInteger)month {
  self.chosenYear = [NSNumber numberWithInteger:year];
  self.chosenMonth = [NSNumber numberWithInteger:month];
  self.ageSet = YES;
}

- (IBAction)ageButtonPushed:(id)sender {
  AgeEntryChoiceViewController* vc = [[AgeEntryChoiceViewController alloc] initWithNibName:nil
                                                                                    bundle:nil
                                                                               patientName:self.patient.name
                                                                         ageChosenDelegate:self];
  [self.navigationController pushViewController:vc animated:YES];
}

- (NSDate*) initialDateForDatePicker {
  if (self.patient.dob.specificdate) {
    return self.patient.dob.specificdate;
  } else if ([self.patient.dob.year intValue] > 0 && [self.patient.dob.month intValue] > 0) {
    return [Utils dateFromMonth:[self.patient.dob.month intValue] day:01 year:[self.patient.dob.year intValue]];
  } else if ([self.patient.dob.year intValue] > 0) {
    return [Utils dateFromMonth:01 day:01 year:[self.patient.dob.year intValue]];
  }
  return nil;
}

// This is connected to the value changed event from the patient name field, so
// we can update the view title.
- (IBAction)nameChanged:(id)sender {
  [self updateTitleFromPatientNameField];
}

- (void) updateTitleFromPatientNameField {
  NSString* nameField = self.patientNameField.text;

  if (!self.patient && [nameField length] == 0) {
    self.title = @"New Patient";
  } else {
    self.title = self.patientNameField.text;
  }
}

- (BOOL) patientFieldsValidForSave {
  return [self.patientNameField.text length] > 0;
}

- (void) highlightInvalidUIElements {
  if ([self.patientNameField.text length] == 0) {
    self.patientNameField.layer.cornerRadius = 8.0f;
    self.patientNameField.layer.masksToBounds = YES;
    self.patientNameField.layer.borderColor = [[UIColor redColor]CGColor];
    self.patientNameField.layer.borderWidth = 1.0f;
  } else {
    self.patientNameField.layer.borderColor = [[UIColor clearColor] CGColor];
  }
}

- (void) saveChangesIfNecessary {
  NSString* newName = self.patientNameField.text;

  BOOL requiresSave = NO;

  // If we're adding a patient and the field length is > 0.
  if (!self.patient && [newName length] > 0) {
    requiresSave = YES;
  } else if (![newName isEqualToString:self.patient.name]) {
    // Or if the user has modified the patient name.
    requiresSave = YES;
  }

  NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
  [f setNumberStyle:NSNumberFormatterDecimalStyle];
  if (self.ageSet) {
    requiresSave = YES;
  }

  if (requiresSave) {
    if (self.patient == nil) {
      Patient* p = [[PatientStore sharedPatientStore] newPatient];
      self.patient = p;
    }
    self.patient.name = newName;
    if (self.ageSet) {
      self.patient.dob.specificdate = self.chosenDate;
    }

    if (self.patient.dob == nil) {
      [NSException raise:@"Patient Save failed"
                  format:@"Reason: patient has no flex date"];
    }
    [[PatientStore sharedPatientStore] saveChanges];
  }

  [self updateUIWithPatient];
}

- (IBAction)cancelButtonAction:(id)sender {
  if (!self.patient) {
    [self.navigationController popViewControllerAnimated:YES];
    return;
  }
  [self unsetAge];
  [self updateUIWithPatient];
  [self setEditing:NO animated:NO];
}

- (void)unsetAge {
  self.ageSet = NO;
  self.chosenDate = nil;
  self.chosenYear = nil;
  self.chosenMonth = nil;

}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  if (editing) {
    [super setEditing:editing animated:animated];
    [self.patientNameField setEnabled:YES];
    [self.patientNameField setBorderStyle:UITextBorderStyleRoundedRect];

    [self.ageButton setTitle:[self.patient.dob toString]
                    forState:UIControlStateNormal];
    [self.patientAgeField setHidden:YES];
    [self.ageButton setHidden:NO];
    [self.toolbar setHidden:NO];
  } else {

    [self highlightInvalidUIElements];

    if (![self patientFieldsValidForSave]) {
      return;
    }

    [super setEditing:editing animated:animated];
    [self.patientNameField setEnabled:NO];
    [self.patientNameField setBorderStyle:UITextBorderStyleNone];

    [self.patientAgeField setHidden:NO];
    [self.ageButton setHidden:YES];

    [self.toolbar setHidden:YES];
    [self saveChangesIfNecessary];
  }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                     andPatient:(Patient*)p {
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self) {
    self.patient = p;
    self.patientVisitStore = [VisitStore sharedVisitStore];
    self.ageSet = NO;
    [self updateTitleFromPatientNameField];
  }

  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
  self = [self initWithNibName:nibNameOrNil
                        bundle:nibBundleOrNil
                    andPatient:nil];
  return self;
}

- (void)updateUIWithPatient {
  [self.patientNameField setText:self.patient.name];
  [self.patientAgeField setText:[self.patient.dob toString]];
  [self updateTitleFromPatientNameField];

}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationItem setRightBarButtonItem:[self editButtonItem]];
  if (self.patient != nil) {
    [self updateUIWithPatient];
    [self setEditing:NO animated:NO];
  } else {
    [self setEditing:YES animated:NO];
  }
  [self.ageButton setTitle:[self.patient.dob toString] forState:UIControlStateNormal];
  self.ageButton.titleLabel.textAlignment = NSTextAlignmentCenter;

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}



- (void) keyboardWillShow: (NSNotification *)notification {
  UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
  NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  CGRect keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  [UIView beginAnimations:nil context: nil];
  [UIView setAnimationCurve:animationCurve];
  [UIView setAnimationDuration:animationDuration];
  [self.toolbar setFrame:CGRectMake(0.0f,
                                    self.view.frame.size.height - keyboardBounds.size.height - self.toolbar.frame.size.height,
                                    self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
  [UIView commitAnimations];
}

- (void) keyboardWillHide: (NSNotification *)notification {
  UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
  NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView beginAnimations:nil context: nil];
  [UIView setAnimationCurve:animationCurve];
  [UIView setAnimationDuration:animationDuration];
  [self.toolbar setFrame:CGRectMake(0.0f,
                                    self.view.frame.size.height - 46.0f, self.toolbar.frame.size.width,
                                    self.toolbar.frame.size.height)];
  
  [UIView commitAnimations];
}

@end
