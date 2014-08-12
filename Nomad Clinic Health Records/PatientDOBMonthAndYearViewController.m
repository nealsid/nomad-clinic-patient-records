//
//  PatientDOBMonthAndYearViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/12/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PatientDOBMonthAndYearViewController.h"

#import "AgeEntryChoiceViewController.h"

@interface PatientDOBMonthAndYearViewController ()

@property (weak, nonatomic) id<AgeChosenDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *setAgeButton;
@property (weak, nonatomic) IBOutlet UITextField* monthField;
@property (weak, nonatomic) IBOutlet UITextField* yearField;

@end

@implementation PatientDOBMonthAndYearViewController

- (IBAction)ageButtonPushed:(id)sender {

}

- (IBAction)monthFieldChanged:(id)sender {
  [self updateButtonText];
}

- (IBAction)yearFieldChanged:(id)sender {
  [self updateButtonText];
}

- (void) updateButtonText {
  if (![self.monthField.text isEqualToString:@""] &&
      ![self.yearField.text isEqualToString:@""]) {
    [self.setAgeButton setTitle:@"Set Month and Year" forState:UIControlStateNormal];
    return;
  }

  if (![self.monthField.text isEqualToString:@""]) {
    [self.setAgeButton setTitle:@"Set Month" forState:UIControlStateNormal];
    return;
  }
  if (![self.yearField.text isEqualToString:@""]) {
    [self.setAgeButton setTitle:@"Set Year" forState:UIControlStateNormal];
    return;
  }
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
               ageChosenDelegate:(id<AgeChosenDelegate>)delegate {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.delegate = delegate;
  }
  return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil {
  [NSException raise:@"Wrong initializer"
              format:@"use designated initializer"];
  return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
