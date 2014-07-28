//
//  NEMREntryPointViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/19/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "NEMREntryPointViewController.h"
#import "NEMRPatientsTableViewController.h"

@interface NEMREntryPointViewController ()

@end

@implementation NEMREntryPointViewController

- (IBAction)triageButtonUp:(id)sender {
  UITableViewController* tvc = [[NEMRPatientsTableViewController alloc] init];
  [self.navigationController pushViewController:tvc animated:YES];
  [self.navigationController setNavigationBarHidden:NO];
}
- (IBAction)clinicianButtonUp:(id)sender {
  UITableViewController* tvc = [[NEMRPatientsTableViewController alloc] init];
  [self.navigationController pushViewController:tvc animated:YES];
  [self.navigationController setNavigationBarHidden:NO];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end
