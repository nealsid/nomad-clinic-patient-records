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
#import "VisitNotesComplex+WeightClass.h"
#import "Utils.h"

#import <QuartzCore/QuartzCore.h>

@interface PatientViewController ()

@property (weak, nonatomic)   IBOutlet NSLayoutConstraint *patientNameTopConstraint;
@property (weak, nonatomic)   IBOutlet UIButton *addVisitButton;
@property (weak, nonatomic)   IBOutlet UITextField *patientNameField;

@property                     BOOL adjustedForTopLayout;

@property (nonatomic, retain) Patient* patient;

@property (weak, nonatomic)   BaseStore* visitStore;

/**
 * Constructs an array of field metadata only for fields that specifically exist.
 */
- (void) constructDisplayMetadataFromVisit;

@end

@implementation PatientViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                              target:self
                                                                              action:@selector(editPatient:)];
  [self.navigationItem setRightBarButtonItem:editButton];
  [self.patientNameField setText:@"Most recent visit"];
  [self refreshVisitUI];
  [self.recentVisitTable registerClass:[UITableViewCell class]
                forCellReuseIdentifier:@"UITableViewCell"];
  [self.recentVisitTable registerClass:[UITableViewHeaderFooterView class]
    forHeaderFooterViewReuseIdentifier:@"header"];
}

- (void) viewWillAppear:(BOOL)animated {
  self.title = self.patient.name;
//  [self.patientNameField setText:self.patient.name];
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

- (void) constructDisplayMetadataFromVisit {
  NSMutableArray *visitSpecificFieldMetadata = [NSMutableArray array];
  NSLog(@"Constructing metadata for visit: %@", self.mostRecentVisit.notes);
  for (int i = 0 ; i < self.visitModelDisplayMetadata.count; ++i) {
    NSDictionary* fieldMetadata = self.visitModelDisplayMetadata[i];
    if ([self.mostRecentVisit.notes valueForKey:[fieldMetadata objectForKey:@"fieldName"]] != nil) {
      NSLog(@"Adding field %@, value: %@", [fieldMetadata objectForKey:@"fieldName"], [self.mostRecentVisit.notes valueForKey:[fieldMetadata objectForKey:@"fieldName"]]);
      [visitSpecificFieldMetadata addObject:fieldMetadata];
    }
  }
  self.visitSpecificFieldMetadata = [NSArray arrayWithArray:visitSpecificFieldMetadata];
}

- (NSString*) formatBloodPressure:(VisitNotesComplex*) note {
  return [NSString stringWithFormat:@"%@/%@", note.bp_systolic, note.bp_diastolic];
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
                                                             byRelationName:@"patient"
                                                                  dateField:@"visit_date"];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.adjustedForTopLayout = NO;
    self.hidesBottomBarWhenPushed = YES;
    self.visitModelDisplayMetadata = @[@{@"fieldName":@"healthy",
                                         @"prettyName":@"Is Healthy?"},

                                          @{@"fieldName":@"bp_systolic",
                                            @"prettyName":@"Blood pressure",
                                            @"formatSelector":[NSValue valueWithPointer:@selector(formatBloodPressure:)]},

                                          @{@"fieldName":@"breathing_rate",
                                            @"prettyName":@"Breathing rate"},

                                          @{@"fieldName":@"pulse",
                                            @"prettyName":@"Pulse"},

                                          @{@"fieldName":@"temp_fahrenheit",
                                            @"prettyName":@"Temp (℉)"},

                                          @{@"fieldName":@"weight",
                                            @"prettyName":@"Weight"},

                                          @{@"fieldName":@"weight_class",
                                            @"prettyName":@"Weight class"},

                                          @{@"fieldName":@"subjective",
                                            @"prettyName":@"Subjective"},

                                          @{@"fieldName":@"objective",
                                            @"prettyName":@"Objective"},

                                          @{@"fieldName":@"assessment",
                                            @"prettyName":@"Assessment"},

                                          @{@"fieldName":@"plan",
                                            @"prettyName":@"Plan"},

                                          @{@"fieldName":@"note",
                                            @"prettyName":@"Note"}];
    [self constructDisplayMetadataFromVisit];
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
  v.visit_date = [NSDate date];
  v.notes = (VisitNotesComplex*)[[BaseStore sharedStoreForEntity:@"VisitNotesComplex"] newEntity];
  [v.notes setWeightClass:WeightClassExpected];
  [self.visitStore saveChanges];
  NSLog(@"Saving visit: %@", v);
  [self refreshVisitUI];
  NSLog(@"Called refresh");
  [self animateSectionHeaderBackground];
}

- (void) refreshVisitUI {
  self.mostRecentVisit =  (Visit*)[self.visitStore mostRecentRelatedEntity:@"Visit"
                                                               forInstance:self.patient
                                                            byRelationName:@"patient"
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
