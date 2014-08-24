//
//  ClinicViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/22/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "ClinicViewController.h"
#import "ClinicStore.h"

@interface ClinicViewController ()

@property (nonatomic, retain) ClinicStore* clinicStore;

@end

@implementation ClinicViewController

- (instancetype) init {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.clinicStore = [ClinicStore sharedClinicStore];
  }
  return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style {
  return [self init];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
