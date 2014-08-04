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
#import "PatientVisit.h"
#import "PatientVisitNotes.h"

@interface PatientVisitNoteViewController ()
@property (weak, nonatomic) PatientVisitNotes* note;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *clinicianNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bpLabel;
@property (weak, nonatomic) IBOutlet UILabel *breathingRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pulseLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyTempLabel;

@end

@implementation PatientVisitNoteViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
                patientVisitNote:(PatientVisitNotes*)note {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.note = note;
    self.dateLabel.text = [NSString stringWithFormat:@"%@", note.note_date];
    self.patientNameLabel.text = [NSString stringWithFormat:@"%@", note.patientVisit.patient.name];
    self.clinicianNameLabel.text = [NSString stringWithFormat:@"%@", [(Clinician*)[note.patientVisit.clinician anyObject] name]];
    self.bpLabel.text = [NSString stringWithFormat:@"%@/%@", note.bp_systolic, note.bp_diastolic];
    self.breathingRateLabel.text = [NSString stringWithFormat:@"%@", note.breathing_rate];
    self.pulseLabel.text = [NSString stringWithFormat:@"%@", note.pulse];
    self.bodyTempLabel.text = [NSString stringWithFormat:@"%@ ° F", note.temp_fahrenheit];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
