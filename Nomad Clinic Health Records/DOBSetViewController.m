//
//  DOBSetViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/11/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "DOBSetViewController.h"
#import "AgeEntryChoiceViewController.h"

@interface DOBSetViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *dobPicker;
@property (weak, nonatomic) IBOutlet UIButton *setBirthdayButton;

@property (weak, nonatomic) id<AgeChosenDelegate> delegate;

@end

@implementation DOBSetViewController

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

- (void) viewDidLoad {
  NSDate* initialDate = [self.delegate initialDateForDatePicker];
  if (initialDate) {
    self.dobPicker.date = initialDate;
  }
  self.title = @"Choose birthday";
}

- (IBAction)setBirthdayButtonClicked:(id)sender {
  [self.delegate ageWasChosenByBirthdate:[self.dobPicker date]];
}

- (IBAction)dateSelected:(id)sender {
  NSDate* selectedDate = [self.dobPicker date];
  NSDate* today = [NSDate date];
  if ([selectedDate compare:today] == NSOrderedDescending) {
    [self.dobPicker setDate:today];
  }
}

@end
