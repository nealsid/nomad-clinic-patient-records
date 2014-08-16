//
//  NEMRClinicianViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/28/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "ClinicianViewController.h"
#import "Clinician.h"
#import "CLinicianStore.h"

@interface ClinicianViewController ()

@property (weak, nonatomic) Clinician* clinician;
@property (weak, nonatomic) id<ClinicianViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@end

@implementation ClinicianViewController

- (IBAction)saveButton:(id)sender {
  NSString* newName = self.nameField.text;

  BOOL requiresSave = NO;
  if (self.clinician == nil) {
    Clinician* c = [[ClinicianStore sharedClinicianStore] newClinician];
    self.clinician = c;
  }

  if ((self.clinician.name == nil && [newName length] != 0) ||
      ![newName isEqualToString:self.clinician.name]) {
    requiresSave = YES;
    self.clinician.name = newName;
  }

  if (requiresSave) {
    [[ClinicianStore sharedClinicianStore] saveChanges];
    [self.delegate clinicianViewControllerSave:self
                                     clinician:self.clinician];
  }
}

- (IBAction)cancelButton:(id)sender {
  [self.delegate clinicianViewControllerCancel:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                   andClinician:(Clinician*)c
                   withDelegate:(id<ClinicianViewControllerDelegate>)delegate {
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self) {
    self.clinician = c;
    self.delegate = delegate;
  }

  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
  self = [self initWithNibName:nibNameOrNil
                        bundle:nibBundleOrNil
                  andClinician:nil
                  withDelegate:nil];
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (self.clinician != nil) {
    [self.nameField setText:self.clinician.name];
  }
}


@end
