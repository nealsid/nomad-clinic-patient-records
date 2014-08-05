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
#import "PatientVisitStore.h"
#import "PatientVisitViewController.h"

@interface NEMRPatientViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) Patient* patient;
@property (weak, nonatomic) id<NEMRPatientViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *patientNameField;
@property (weak, nonatomic) IBOutlet UITextField *patientAgeField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *patientPictureCamera;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView* patientVisitTableView;

@property (weak, nonatomic) PatientVisitStore* patientVisitStore;

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
  }
  [self.delegate patientViewControllerSave:self patient:self.patient];
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
    self.patientVisitStore = [PatientVisitStore sharedPatientVisitStore];
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
    [self.patientVisitTableView registerClass:[UITableViewCell class]
                       forCellReuseIdentifier:@"UITableViewCell"];
    [self.patientNameField setText:self.patient.name];
    [self.patientAgeField setText:[NSString stringWithFormat:@"%@",self.patient.age]];
    [self.patientNameField setEnabled:NO];
    [self.patientAgeField setEnabled:NO];
    UIBarButtonItem* editPatientButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                       target:self
                                                                                       action:@selector(editPatient:)];
    [self.navigationItem setRightBarButtonItem:editPatientButton];

  }
}

- (void)editPatient:(id)sender {
  [self.patientNameField setEnabled:YES];
  [self.patientAgeField setEnabled:YES];
  [self.patientNameField setBorderStyle:UITextBorderStyleRoundedRect];
  [self.patientAgeField setBorderStyle:UITextBorderStyleRoundedRect];

  UIBarButtonItem* doneEditingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                     target:self
                                                                                     action:@selector(doneEditingPatient:)];
  [self.navigationItem setRightBarButtonItem:doneEditingButton];
}

- (void)doneEditingPatient:(id)sender {
  [self.patientNameField setEnabled:NO];
  [self.patientAgeField setEnabled:NO];
  [self.patientNameField setBorderStyle:UITextBorderStyleNone];
  [self.patientAgeField setBorderStyle:UITextBorderStyleNone];
  UIBarButtonItem* editPatientButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                     target:self
                                                                                     action:@selector(editPatient:)];
  [self.navigationItem setRightBarButtonItem:editPatientButton];
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
