//
//  NEMRNewPatientViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "PatientViewController.h"

#import "BaseStore.h"
#import "DOBSetViewController.h"
#import "FlexDate.h"
#import "FlexDate+ToString.h"
#import "Patient.h"
#import "PatientAddEditViewController.h"
#import "PatientViewController+TableView.h"
#import "SOAPViewController.h"
#import "Visit.h"
#import "VisitNotesComplex.h"
#import "Utils.h"

#import <QuartzCore/QuartzCore.h>

@interface PatientViewController ()

@property (weak, nonatomic)   IBOutlet NSLayoutConstraint *patientNameTopConstraint;
@property (weak, nonatomic)   IBOutlet UIButton *addVisitButton;
@property (weak, nonatomic)   IBOutlet UITextField *patientNameField;

@property                     BOOL adjustedForTopLayout;

@property (nonatomic, retain) Patient* patient;

@property (weak, nonatomic)   BaseStore* visitStore;
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
  [self.recentVisitTable registerClass:[UITableViewHeaderFooterView class]
    forHeaderFooterViewReuseIdentifier:@"header"];
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
    self.visitStore = [BaseStore sharedStoreForEntity:@"Visit"];
    self.mostRecentVisit = (Visit*)[self.visitStore mostRecentRelatedEntity:@"Visit"
                                                                forInstance:self.patient
                                                                  dateField:@"visit_date"];
    self.adjustedForTopLayout = NO;
    self.hidesBottomBarWhenPushed = YES;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
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

- (IBAction)addVisitButtonClicked:(id)sender {
  Visit* v = (Visit *)[self.visitStore newEntity];
  v.patient = self.patient;
  [self refreshVisitUI];
  NSLog(@"Called refresh");
  [self animateSectionHeaderBackground];
}

- (void) refreshVisitUI {
  self.mostRecentVisit =  (Visit*)[self.visitStore mostRecentRelatedEntity:@"Visit"
                                                               forInstance:self.patient
                                                                 dateField:@"visit_date"];
  [self.recentVisitTable reloadData];
}

- (void) isHealthySwitchClicked:(id)sender {
  UISwitch* healthSwitch = (UISwitch*)sender;
  self.mostRecentVisit.notes.healthy = [NSNumber numberWithBool:healthSwitch.isOn];
  [self.visitStore saveChanges];
  [self.recentVisitTable reloadData];
}

- (void) newFieldValue:(NSNumber*)newValue {
  self.mostRecentVisit.notes.weight_class = newValue;
  [self.visitStore saveChanges];
  [self.recentVisitTable reloadData];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) soapViewController:(SOAPViewController*)vc saveNewNote:(NSString*)s
                    forType:(SOAPEntryType)type {
  self.mostRecentVisit.notes.objective = s;
  [self.visitStore saveChanges];
  [self.recentVisitTable reloadData];
  [self.navigationController popViewControllerAnimated:YES];

}

@end
