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
#import "NEMRPatientViewController.h"
#import "Patient.h"
#import "PatientStore.h"
#import "PatientVisitStore.h"
#import "PatientVisitViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface NEMRPatientViewController () <UITableViewDataSource,UITableViewDelegate, AgeChosenDelegate>

@property (nonatomic, retain) Patient* patient;

@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITextField *patientAgeField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView* patientVisitTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;

@property (weak, nonatomic) PatientVisitStore* patientVisitStore;

@property (strong, nonatomic) NSDate* chosenDate;
@property NSNumber* chosenYear;
@property NSNumber* chosenMinYear;
@property NSNumber* chosenMaxYear;
@property BOOL ageSet;

- (void) updateTitleFromPatientNameField;

@end

@implementation NEMRPatientViewController

- (void)ageWasChosenByBirthdate:(NSDate *)birthDate {
  self.chosenDate = birthDate;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateStyle = NSDateFormatterMediumStyle;
  formatter.timeStyle = NSDateFormatterNoStyle;
  self.patientAgeField.text = [formatter stringFromDate:birthDate];
  self.ageSet = YES;
  [self.navigationController popToViewController:self animated:YES];
}

- (void)ageWasChosenByYear:(NSInteger)year {
  self.chosenYear = [NSNumber numberWithInteger:year];
  self.ageSet = YES;
}

- (void)ageWasChosenByYearRange:(NSInteger)minYear
                             to:(NSInteger)maxYear {
  self.chosenMinYear = [NSNumber numberWithInteger:minYear];
  self.chosenMaxYear = [NSNumber numberWithInteger:maxYear];
  self.ageSet = YES;
}

- (IBAction)ageButtonPushed:(id)sender {
  AgeEntryChoiceViewController* vc = [[AgeEntryChoiceViewController alloc] initWithNibName:nil
                                                                                    bundle:nil
                                                                               patientName:self.patient.name
                                                                         ageChosenDelegate:self];
  [self.navigationController pushViewController:vc animated:YES];
}

// This is connected to the value changed event, so we can update the
// view title.
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
  return [self.patientNameField.text length] > 0 &&
    [self.patientAgeField.text length] > 0;
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

  if ([self.patientAgeField.text length] == 0) {
    self.patientAgeField.layer.cornerRadius = 8.0f;
    self.patientAgeField.layer.masksToBounds = YES;
    self.patientAgeField.layer.borderColor = [[UIColor redColor]CGColor];
    self.patientAgeField.layer.borderWidth = 1.0f;
  } else {
    self.patientAgeField.layer.borderColor = [[UIColor clearColor] CGColor];
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
//  NSNumber * newAge = [f numberFromString:self.patientAgeField.text];

//  if ((self.patient.age == nil && [self.patientAgeField.text length] != 0) ||
//      ![newAge isEqualToNumber:self.patient.age]) {
//    requiresSave = YES;
//  }

  if (requiresSave) {
    if (self.patient == nil) {
      Patient* p = [[PatientStore sharedPatientStore] newPatient];
      self.patient = p;
    }
    self.patient.name = newName;
//    self.patient.age = newAge;
    [[PatientStore sharedPatientStore] saveChanges];
  }

  [self updateUIWithPatient];
}

- (IBAction)cancelButtonAction:(id)sender {
  if (!self.patient) {
    [self.navigationController popViewControllerAnimated:YES];
    return;
  }
  [self updateUIWithPatient];
  [self setEditing:NO animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  if (editing) {
    [super setEditing:editing animated:animated];
    [self.patientNameField setEnabled:YES];
    [self.patientNameField setBorderStyle:UITextBorderStyleRoundedRect];

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
    self.patientVisitStore = [PatientVisitStore sharedPatientVisitStore];
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
    [self.patientVisitTableView registerClass:[UITableViewCell class]
                       forCellReuseIdentifier:@"UITableViewCell"];
    [self updateUIWithPatient];
    [self setEditing:NO animated:NO];
  } else {
    [self setEditing:YES animated:NO];
  }
  [self.ageButton setTitle:[self.patient.dob toString] forState:UIControlStateNormal];
  self.ageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [[[PatientVisitStore sharedPatientVisitStore]
           patientVisitsForPatient:self.patient] count] + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (BOOL) isLastRow:(NSInteger)rowNumber {
  return rowNumber == ([[self.patientVisitStore patientVisitsForPatient:self.patient] count]);
}

- (BOOL)    tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (BOOL)                     tableView:(UITableView *)tableView
shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  return ![self isLastRow: [indexPath row]];
}

- (BOOL)              tableView:(UITableView *)tableView
shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
  return ![self isLastRow: [indexPath row]];
}

- (BOOL)    tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return ![self isLastRow:[indexPath row]];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
  return @"Visits";
}

- (BOOL)            tableView:(UITableView *)tableView
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  if ([self isLastRow:row]) {
    return NO;
  }
  return YES;
}

- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  if (![self isLastRow:row]) {
    return 60;
  }
  return 44;
}

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  UITableViewCell* cell =
      [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:@"UITableViewCell"];
  [cell setBackgroundColor:nil];
  if ([self isLastRow:row]) {
    cell.textLabel.text = @"No more patient visits";
    return cell;
  }
  if (row > [[self.patientVisitStore patientVisitsForPatient:self.patient] count]) {
    return nil;
  }
  PatientVisit* pv = [[self.patientVisitStore patientVisitsForPatient:self.patient] objectAtIndex:row];
  cell.textLabel.text = [NSString stringWithFormat:@"%@",
                         pv.visit_date];
  return cell;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  PatientVisit* pv = [[self.patientVisitStore patientVisitsForPatient:self.patient] objectAtIndex:row];
  PatientVisitViewController* pvvc =
      [[PatientVisitViewController alloc] initWithNibName:nil
                                                   bundle:nil
                                             patientVisit:pv];

  [self.navigationController pushViewController:pvvc animated:YES];
}

@end
