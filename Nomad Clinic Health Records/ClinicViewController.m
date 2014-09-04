//
//  ClinicViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/22/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "Clinic.h"
#import "ClinicViewController.h"

#import "Clinic.h"
#import "ClinicStore.h"
#import "PatientStore.h"
#import "PatientsTableViewController.h"
#import "Village.h"

@interface ClinicViewController ()

@property (nonatomic, retain) ClinicStore* clinicStore;
@property (nonatomic, retain) NSArray* clinics;

@property (nonatomic, retain) UIFont* itemFont;

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
    self.itemFont = [UIFont fontWithName:@"American Typewriter" size:32];
  }
  return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style {
  return [self init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.title = @"Clinics";
  
  self.navigationController.navigationBar.titleTextAttributes =
  [NSDictionary dictionaryWithObjects:@[[UIColor blackColor],
                                        [UIFont boldSystemFontOfSize:24]]
                              forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
  UIBarButtonItem* newClinicButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(addNewClinic:)];
  self.navigationItem.rightBarButtonItem = newClinicButton;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
   Clinic* c = [self.clinics objectAtIndex:row];

  NSLog(@"Clinic selected: %@", c);
  PatientsTableViewController* pvc =
  [[PatientsTableViewController alloc] initForClinic:c];

  [self.navigationController pushViewController:pvc animated:YES];
}

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  UITableViewCell* cell =
  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                         reuseIdentifier:@"UITableViewCell"];
  cell.textLabel.textColor = [UIColor darkGrayColor];
  cell.backgroundColor = [UIColor clearColor];
  cell.textLabel.font = self.itemFont;
  if ([self isLastRow:row]) {
    cell.textLabel.text = @"No more clinics";
    return cell;
  }
  [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  if (row > [self.clinics count]) {
    return nil;
  }
  Clinic* c = [self.clinics objectAtIndex:row];
  cell.textLabel.text = c.village.name;
  return cell;
}


@end
