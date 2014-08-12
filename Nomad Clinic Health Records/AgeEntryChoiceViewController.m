//
//  AgeEditViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/8/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "AgeEntryChoiceViewController.h"

#import "DOBSetViewController.h"
#import "PatientDOBMonthAndYearViewController.h"

#import <UIKit/UIKit.h>

@interface AgeEntryChoiceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *yearAndMonthButton;
@property (weak, nonatomic) IBOutlet UIButton *dobButton;

@property (weak, nonatomic) id<AgeChosenDelegate> delegate;
@property (weak, nonatomic) NSString* patientName;

@end

@implementation AgeEntryChoiceViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
                     patientName:(NSString*)patientName
               ageChosenDelegate:(id<AgeChosenDelegate>)delegate {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.delegate = delegate;
    self.patientName = patientName;
    self.title = self.patientName;
  }
  return self;
}

- (IBAction)yearAndMonthButton:(id)sender {
  PatientDOBMonthAndYearViewController* dobVc = [[PatientDOBMonthAndYearViewController alloc] initWithNibName:nil
                                                                       bundle:nil
                                                            ageChosenDelegate:self.delegate];
  [self.navigationController pushViewController:dobVc animated:YES];

}

- (IBAction)dateOfBirthButton:(id)sender {
  DOBSetViewController* dobVc = [[DOBSetViewController alloc] initWithNibName:nil
                                                                       bundle:nil
                                                            ageChosenDelegate:self.delegate];
  [self.navigationController pushViewController:dobVc animated:YES];
}

@end
