//
//  NEMRNewPatientViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "DOBSetViewController.h"
#import "FlexDate.h"
#import "FlexDate+ToString.h"
#import "PatientViewController.h"
#import "Patient.h"
#import "PatientStore.h"
#import "SOAPViewController.h"
#import "Visit.h"
#import "VisitNotesComplex.h"
#import "VisitStore.h"
#import "Utils.h"

#import <QuartzCore/QuartzCore.h>

@interface PatientViewController () <AgeChosenDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *patientNameTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomConstraint;

@property (nonatomic, retain) Patient* patient;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *addVisitButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;
@property (weak, nonatomic) IBOutlet UITableView *recentVisitTable;
@property (weak, nonatomic) IBOutlet UITextField *patientAgeField;
@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) VisitStore* patientVisitStore;

@property (strong, nonatomic) NSDate* chosenDate;
@property NSNumber* chosenYear;
@property NSNumber* chosenMonth;
@property BOOL ageSet;

@property BOOL adjustedForTopLayout;

@end

@implementation PatientViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationItem setRightBarButtonItem:[self editButtonItem]];
  if (self.patient != nil) {
    [self updateUIWithPatient];
    [self.genderControl setSelectedSegmentIndex:[self.patient.gender intValue]];
    [self setEditing:NO animated:NO];
  } else {
    [self setEditing:YES animated:NO];
    [self.recentVisitTable setHidden:YES];
  }
  NSLog(@"%@", self.tabBarController);

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  [self.recentVisitTable registerClass:[UITableViewCell class]
                forCellReuseIdentifier:@"UITableViewCell"];
}

- (void) viewDidLayoutSubviews {
  if (!self.adjustedForTopLayout) {
    CGFloat topLayoutGuideLength = [self.topLayoutGuide length];
//    CGFloat bottomLayoutGuideLength = [self.bottomLayoutGuide length];
    self.patientNameTopConstraint.constant += topLayoutGuideLength;
    [self.view layoutSubviews];
    self.adjustedForTopLayout = YES;
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
    self.mostRecentVisit = [self.patientVisitStore mostRecentVisitForPatient:self.patient];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.adjustedForTopLayout = NO;
    self.hidesBottomBarWhenPushed = YES;
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

- (BOOL) patientFieldsValidForSave {
  return [self.patientNameField.text length] > 0;
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

  if (self.genderControl.enabled &&
      self.genderControl.selectedSegmentIndex != [self.patient.gender integerValue]) {
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
    self.patient.gender = [NSNumber numberWithInteger:self.genderControl.selectedSegmentIndex];
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
  [self.genderControl setSelectedSegmentIndex:[self.patient.gender intValue]];
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

    [self.patientAgeField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.patientAgeField setEnabled:YES];
    [self.addVisitButton setHidden:YES];
    [self.toolbar setHidden:NO];
    for (NSUInteger i = 0; i < self.genderControl.numberOfSegments; ++i) {
      [self.genderControl setEnabled:YES forSegmentAtIndex:i];
    }
    self.genderControl.selectedSegmentIndex = [self.patient.gender integerValue];
    [self.recentVisitTable setHidden:YES];
  } else {

    [self highlightInvalidUIElements];

    if (![self patientFieldsValidForSave]) {
      return;
    }

    [super setEditing:editing animated:animated];
    [self.patientNameField setEnabled:NO];
    [self.patientNameField setBorderStyle:UITextBorderStyleNone];
    [self.patientAgeField setBorderStyle:UITextBorderStyleNone];
    [self.patientAgeField setEnabled:NO];

    [self.patientAgeField setHidden:NO];
    [self.addVisitButton setHidden:NO];

    [self.toolbar setHidden:YES];

    for (NSUInteger i = 0; i < self.genderControl.numberOfSegments; ++i) {
      if (i != [self.genderControl selectedSegmentIndex]) {
        [self.genderControl setEnabled:NO forSegmentAtIndex:i];
      }
    }
    [self.recentVisitTable setHidden:NO];

    [self saveChangesIfNecessary];
  }
}

- (void)updateUIWithPatient {
  [self.patientNameField setText:self.patient.name];
  [self.patientAgeField setText:[NSString stringWithFormat:@"Born %@",[self.patient.dob toString]]];

  [self refreshVisitUI];
}

- (void) keyboardWillShow: (NSNotification *)notification {
  UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
  NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  CGRect keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  keyboardBounds = [self.view convertRect:keyboardBounds fromView:nil];
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:animationCurve];
  [UIView setAnimationDuration:animationDuration];
  self.toolbarBottomConstraint.constant = keyboardBounds.size.height;
  [self.toolbar setFrame:CGRectMake(0.0f,
                                    self.view.frame.size.height - keyboardBounds.size.height - self.toolbar.frame.size.height,
                                    self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
  [self.view layoutIfNeeded];
  [UIView commitAnimations];
}

- (void) keyboardWillHide: (NSNotification *)notification {
  UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
  NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView beginAnimations:nil context: nil];
  [UIView setAnimationCurve:animationCurve];
  [UIView setAnimationDuration:animationDuration];
  self.toolbarBottomConstraint.constant = 0;

  [self.toolbar setFrame:CGRectMake(0.0f,
                                    self.view.frame.size.height - 46.0f, self.toolbar.frame.size.width,
                                    self.toolbar.frame.size.height)];
  [self.view layoutIfNeeded];
  [UIView commitAnimations];
}

- (IBAction)addVisitButtonClicked:(id)sender {
  Visit* v = [self.patientVisitStore newVisitForPatient:self.patient];
  self.mostRecentVisit = v;
  [self refreshVisitUI];
}

- (void) refreshVisitUI {
  self.mostRecentVisit = [self.patientVisitStore mostRecentVisitForPatient:self.patient];
  self.recentVisitTable.hidden = NO;
  [self.recentVisitTable reloadData];
}

- (void) isHealthySwitchClicked:(id)sender {
  UISwitch* healthSwitch = (UISwitch*)sender;
  self.mostRecentVisit.notes.healthy = [NSNumber numberWithBool:healthSwitch.isOn];
  [self.patientVisitStore saveChanges];
  [self.recentVisitTable reloadData];
}

- (void) newFieldValue:(NSNumber*)newValue {
  self.mostRecentVisit.notes.weight = newValue;
  [self.patientVisitStore saveChanges];
  [self.recentVisitTable reloadData];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) soapViewController:(SOAPViewController*)vc saveNewNote:(NSString*)s
                    forType:(SOAPEntryType)type {
  self.mostRecentVisit.notes.objective = s;
  [self.patientVisitStore saveChanges];
  [self.recentVisitTable reloadData];
  [self.navigationController popViewControllerAnimated:YES];

}

- (void)ageWasChosenByBirthdate:(NSDate *)birthDate {
  self.chosenDate = birthDate;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateStyle = NSDateFormatterMediumStyle;
  formatter.timeStyle = NSDateFormatterNoStyle;
  self.ageSet = YES;
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) ageWasChosenByMonthAndOrYear:(NSInteger)year
                             andMonth:(NSInteger)month {
  self.chosenYear = [NSNumber numberWithInteger:year];
  self.chosenMonth = [NSNumber numberWithInteger:month];
  self.ageSet = YES;
}

- (IBAction)ageButtonPushed:(id)sender {
  DOBSetViewController* vc = [[DOBSetViewController alloc] initWithNibName:nil
                                                                    bundle:nil
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

@end
