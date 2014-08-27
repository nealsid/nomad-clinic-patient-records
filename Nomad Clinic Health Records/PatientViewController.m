//
//  NEMRNewPatientViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "PatientViewController.h"

#import "DOBSetViewController.h"
#import "FlexDate.h"
#import "FlexDate+ToString.h"
#import "Patient.h"
#import "PatientAddEditViewController.h"
#import "PatientStore.h"
#import "SOAPViewController.h"
#import "Visit.h"
#import "VisitNotesComplex.h"
#import "VisitStore.h"
#import "Utils.h"

#import <QuartzCore/QuartzCore.h>

@interface PatientViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *patientNameTopConstraint;
@property BOOL adjustedForTopLayout;

@property (nonatomic, retain) Patient* patient;

@property (weak, nonatomic) IBOutlet UIButton *addVisitButton;
@property (weak, nonatomic) IBOutlet UITableView *recentVisitTable;
@property (weak, nonatomic) IBOutlet UITextField *patientNameField;

@property (weak, nonatomic) VisitStore* patientVisitStore;
@property (nonatomic, strong) NSDateFormatter* formatter;

@end

@implementation PatientViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                              target:self
                                                                              action:@selector(editPatient:)];
  [self.navigationItem setRightBarButtonItem:editButton];
  [self.patientNameField setText:self.patient.name];
  [self refreshVisitUI];
  [self.recentVisitTable registerClass:[UITableViewCell class]
                forCellReuseIdentifier:@"UITableViewCell"];
}

- (void) viewWillAppear:(BOOL)animated {
  [self.patientNameField setText:self.patient.name];
  [self refreshVisitUI];
}

- (void) editPatient:(id)sender {
  PatientAddEditViewController* pvc = [[PatientAddEditViewController alloc] initForPatient:self.patient];
  [self.navigationController pushViewController:pvc animated:YES];
}

- (void) viewDidLayoutSubviews {
  if (!self.adjustedForTopLayout) {
    CGFloat topLayoutGuideLength = [self.topLayoutGuide length];
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
    self.mostRecentVisit = [self.patientVisitStore mostRecentVisitForPatient:self.patient];
    self.adjustedForTopLayout = NO;
    self.hidesBottomBarWhenPushed = YES;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
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

//- (BOOL) patientFieldsValidForSave {
//  return [self.patientNameField.text length] > 0;
//}
//
//- (void) highlightInvalidUIElements {
//  if ([self.patientNameField.text length] == 0) {
//    self.patientNameField.layer.masksToBounds = YES;
//    self.patientNameField.layer.borderColor = [[UIColor redColor] CGColor];
//    self.patientNameField.layer.borderWidth = 1.0f;
//  } else {
//    self.patientNameField.layer.borderColor = [[UIColor clearColor] CGColor];
//  }
//}
//
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//  if (editing) {
//    [super setEditing:editing animated:animated];
//    [self.patientNameField setEnabled:YES];
//    [self.patientNameField setBorderStyle:UITextBorderStyleRoundedRect];
//
//    [self.patientAgeField setBorderStyle:UITextBorderStyleRoundedRect];
//    [self.patientAgeField setEnabled:YES];
//    [self.addVisitButton setHidden:YES];
//    [self.toolbar setHidden:NO];
//    for (NSUInteger i = 0; i < self.genderControl.numberOfSegments; ++i) {
//      [self.genderControl setEnabled:YES forSegmentAtIndex:i];
//    }
//    self.genderControl.selectedSegmentIndex = [self.patient.gender integerValue];
//    [self.recentVisitTable setHidden:YES];
//  } else {
//
//    [self highlightInvalidUIElements];
//
//    if (![self patientFieldsValidForSave]) {
//      return;
//    }
//
//    [super setEditing:editing animated:animated];
//    [self.patientNameField setEnabled:NO];
//    [self.patientNameField setBorderStyle:UITextBorderStyleNone];
//    [self.patientAgeField setBorderStyle:UITextBorderStyleNone];
//    [self.patientAgeField setEnabled:NO];
//
//    [self.patientAgeField setHidden:NO];
//    [self.addVisitButton setHidden:NO];
//
//    [self.toolbar setHidden:YES];
//
//    for (NSUInteger i = 0; i < self.genderControl.numberOfSegments; ++i) {
//      if (i != [self.genderControl selectedSegmentIndex]) {
//        [self.genderControl setEnabled:NO forSegmentAtIndex:i];
//      }
//    }
//    [self.recentVisitTable setHidden:NO];
//
//    [self saveChangesIfNecessary];
//  }
//}

- (IBAction)addVisitButtonClicked:(id)sender {
  Visit* v = [self.patientVisitStore newVisitForPatient:self.patient];
  self.mostRecentVisit = v;
  [self refreshVisitUI];
}

- (void) refreshVisitUI {
  self.mostRecentVisit = [self.patientVisitStore mostRecentVisitForPatient:self.patient];
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

@end
