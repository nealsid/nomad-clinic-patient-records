//
//  PatientVisitViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/29/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PatientVisitViewController.h"
#import "patientVisit.h"

@interface PatientVisitViewController ()

@property (weak, nonatomic) PatientVisit* patientVisit;

@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *clinicianNameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *notesView;
@property (weak, nonatomic) IBOutlet UIScrollView *notesLabel;

@end

@implementation PatientVisitViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end
