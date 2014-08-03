//
//  PatientVisitViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/29/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PatientVisitViewController.h"

#import "PatientVisit.h"
#import "PatientVisitNotes.h"
#import "Patient.h"
#import "Clinician.h"
#import "PatientVisitStore.h"

@interface PatientVisitViewController ()

@property (weak, nonatomic) PatientVisit* patientVisit;
@property (weak, nonatomic) NSArray* notes;

@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *clinicianNameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *notesView;
@property (weak, nonatomic) IBOutlet UITextView *notesTextField;

@end

@implementation PatientVisitViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.patientNameLabel.text = self.patientVisit.patient.name;
  self.clinicianNameLabel.text = [[self.patientVisit.clinician anyObject] name];

  PatientVisitStore* pvstore = [PatientVisitStore sharedPatientVisitStore];
  self.notes = [pvstore notesForPatientVisit:self.patientVisit];
  self.notesTextField.text = @"";
  for (PatientVisitNotes* oneNote in self.notes) {
    self.notesTextField.text = [self.notesTextField.text stringByAppendingString:oneNote.note];
    self.notesTextField.text = [self.notesTextField.text stringByAppendingString:@"\n"];
  }
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
                    patientVisit:(PatientVisit*)pv {
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self) {
    self.patientVisit = pv;
  }
  return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil {
  [NSException raise:@"Unsupported initializer"
              format:@"Reason: You must use the designated initializer for this class"];
  return nil;

}

@end
