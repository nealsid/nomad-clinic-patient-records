//
//  ClinicViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/22/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "Clinic.h"
#import "ClinicViewController.h"
#import "ClinicStore.h"
#import "PatientStore.h"
#import "Village.h"

@interface ClinicViewController ()

@property (nonatomic, retain) ClinicStore* clinicStore;
@property (nonatomic, retain) NSArray* clinics;

@end

@implementation ClinicViewController

- (instancetype) init {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    NSLog(@"%lu patients", (long)[[[PatientStore sharedPatientStore] patients] count]);
    self.clinicStore = [ClinicStore sharedClinicStore];
    self.clinics = [self.clinicStore clinics];
    self.numberOfRows = self.clinics.count;
    self.title = @"Clinics";
  }
  return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style {
  return [self init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Clinics";
  self.navigationController.navigationBar.titleTextAttributes =
  [NSDictionary dictionaryWithObjects:@[[UIColor darkGrayColor], [UIFont fontWithName:@"MarkerFelt-Thin" size:24.0]] forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
}


- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell* cell =
  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                         reuseIdentifier:@"UITableViewCell"];
  cell.textLabel.textColor = [UIColor darkGrayColor];
  cell.backgroundColor = [UIColor clearColor];
  Clinic* c = [self.clinics objectAtIndex:[indexPath row]];
  Village* v = c.village;
  cell.textLabel.text = v.name;
  return cell;
}


@end
