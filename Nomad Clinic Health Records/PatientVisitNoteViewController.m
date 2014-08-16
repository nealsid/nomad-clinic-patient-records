//
//  PatientVisitNoteViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/2/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PatientVisitNoteViewController.h"

#import "Clinician.h"
#import "Patient.h"
#import "Visit.h"
#import "VisitNotesComplex.h"
#import "PatientVisitStore.h"
#import "SOAPViewController.h"

@interface PatientVisitNoteViewController ()
@property (weak, nonatomic) VisitNotesComplex* note;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *clinicianNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bpLabel;
@property (weak, nonatomic) IBOutlet UILabel *breathingRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pulseLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyTempLabel;

@property (weak, nonatomic) IBOutlet UIButton *subjectiveButton;
@property (weak, nonatomic) IBOutlet UIButton *objectiveButton;
@property (weak, nonatomic) IBOutlet UIButton *assessmentButton;
@property (weak, nonatomic) IBOutlet UIButton *planButton;

- (void)displayNoteInUI;

@end

@implementation PatientVisitNoteViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
                patientVisitNote:(VisitNotesComplex*)note {
  
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.note = note;
  }
  return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil {
  [NSException raise:@"Unsupported initializer"
              format:@"Reason: You must use the designated initializer for this class"];
  return nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self displayNoteInUI];
}

- (void)displayNoteInUI {
  self.dateLabel.text = [NSString stringWithFormat:@"%@", self.note.visit.visit_date];
  self.patientNameLabel.text = [NSString stringWithFormat:@"%@", self.note.visit.patient.name];
  self.clinicianNameLabel.text = [NSString stringWithFormat:@"%@",
                                  [(Clinician*)[self.note.visit.clinician anyObject] name]];
  self.bpLabel.text = [NSString stringWithFormat:@"%@/%@", self.note.bp_systolic, self.note.bp_diastolic];
  self.breathingRateLabel.text = [NSString stringWithFormat:@"%@", self.note.breathing_rate];
  self.pulseLabel.text = [NSString stringWithFormat:@"%@", self.note.pulse];
  self.bodyTempLabel.text = [NSString stringWithFormat:@"%@ ° F", self.note.temp_fahrenheit];

  [self.subjectiveButton setTitle:self.note.subjective forState:UIControlStateNormal];
  [self.objectiveButton setTitle:self.note.objective forState:UIControlStateNormal];
  [self.assessmentButton setTitle:self.note.assessment forState:UIControlStateNormal];
  [self.planButton setTitle:self.note.plan forState:UIControlStateNormal];
}
- (IBAction)soapButton:(id)sender {
  SOAPViewController* soapVc;
  SOAPEntryType entryType = S;
  NSString* noteText;

  if (sender == self.subjectiveButton) {
    entryType = S;
    noteText = self.note.subjective;
  }
  if (sender == self.objectiveButton) {
    entryType = O;
    noteText = self.note.objective;
  }
  if (sender == self.assessmentButton) {
    entryType = A;
    noteText = self.note.assessment;
  }
  if (sender == self.planButton) {
    entryType = P;
    noteText = self.note.plan;
  }

  soapVc = [[SOAPViewController alloc] initWithNibName:nil
                                                bundle:nil
                                              soapType:entryType
                                                  note:noteText
                                              delegate:self];
  
  [self.navigationController pushViewController:soapVc animated:YES];
}

- (void) soapViewController:(SOAPViewController *)vc
                saveNewNote:(NSString *)newNote
                    forType:(SOAPEntryType)type {
  switch(type) {
    case S:
      self.note.subjective = newNote;
      break;
    case O:
      self.note.objective = newNote;
      break;
    case A:
      self.note.assessment = newNote;
      break;
    case P:
      self.note.plan = newNote;
      break;
  }
  [[PatientVisitStore sharedPatientVisitStore] saveChanges];
  [self displayNoteInUI];
}


@end
