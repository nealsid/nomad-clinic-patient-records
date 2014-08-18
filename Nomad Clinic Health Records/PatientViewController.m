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
#import "NumberFieldViewController.h"
#import "PatientViewController.h"
#import "Patient.h"
#import "PatientStore.h"
#import "Visit.h"
#import "VisitNotesComplex.h"
#import "VisitStore.h"
#import "Utils.h"

#import <QuartzCore/QuartzCore.h>

@interface PatientViewController () <AgeChosenDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) Patient* patient;

@property (weak, nonatomic) IBOutlet UIButton *addVisitButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;
@property (weak, nonatomic) IBOutlet UITextField *patientAgeField;
@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UITableView *recentVisitTable;

@property (weak, nonatomic) VisitStore* patientVisitStore;
@property (strong, nonatomic) Visit* mostRecentVisit;

@property (strong, nonatomic) NSDate* chosenDate;
@property NSNumber* chosenYear;
@property NSNumber* chosenMonth;
@property BOOL ageSet;

@end

@implementation PatientViewController

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

- (void)updateUIWithPatient {
  [self.patientNameField setText:self.patient.name];
  [self.patientAgeField setText:[self.patient.dob toString]];
}

- (void) keyboardWillShow: (NSNotification *)notification {
  UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
  NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  CGRect keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  keyboardBounds = [self.view convertRect:keyboardBounds fromView:nil];
  [UIView beginAnimations:nil context: nil];
  [UIView setAnimationCurve:animationCurve];
  [UIView setAnimationDuration:animationDuration];
  [self.toolbar setFrame:CGRectMake(0.0f,
                                    self.view.frame.size.height - keyboardBounds.size.height - self.toolbar.frame.size.height,
                                    self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
  [UIView commitAnimations];
  [self.view bringSubviewToFront:self.toolbar];
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

- (IBAction)addVisitButtonClicked:(id)sender {
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (BOOL)    tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (BOOL)    tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (CGFloat)    tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
  return 40;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (NSString*) tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
  return @"Most recent visit";
}

- (CGFloat)    tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
  return 0;
}

- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (BOOL)            tableView:(UITableView *)tableView
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([indexPath row] == 0) {
    NumberFieldViewController *vc = [[NumberFieldViewController alloc] initWithNibName:nil bundle:nil fieldName:@"Weight" initialValue:@"160"];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                 reuseIdentifier:@"UITableViewCell"];

  cell.textLabel.textColor = [UIColor darkGrayColor];
  if (row == 0) {
    cell.textLabel.text = @"Weight";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ lbs", self.mostRecentVisit.notes.weight];
  } else {
    cell.textLabel.text = @"Healthy?";
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchView addTarget:self
                   action:@selector(switchClicked:)
         forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchView;
    switchView.on = [self.mostRecentVisit.notes.healthy boolValue];
    if (![self.mostRecentVisit.notes.healthy boolValue]) {
      cell.textLabel.textColor = [UIColor redColor];
    }
  }
  return cell;
}

- (IBAction) switchClicked:(id)sender {
  UISwitch* healthSwitch = (UISwitch*)sender;
  self.mostRecentVisit.notes.healthy = [NSNumber numberWithBool:healthSwitch.isOn];
  [self.patientVisitStore saveChanges];
  [self.recentVisitTable reloadData];
}

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

@end
