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

@property (weak, nonatomic) IBOutlet UITextField* monthField;
@property (weak, nonatomic) IBOutlet UITextField* yearField;
@end

@implementation PatientDOBMonthAndYearViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
