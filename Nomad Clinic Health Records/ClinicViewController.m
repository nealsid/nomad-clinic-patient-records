//
//  ClinicViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/22/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "ClinicViewController.h"

#import "Clinic.h"
#import "ClinicStore.h"
#import "PatientStore.h"
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
    NSLog(@"%lu", (unsigned long)[[[PatientStore sharedPatientStore] patients] count]);
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
  self.navigationController.navigationBar.titleTextAttributes =
  [NSDictionary dictionaryWithObjects:@[[UIColor darkGrayColor], [UIFont fontWithName:@"MarkerFelt-Thin" size:24.0]] forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
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
  [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
  if (row > [self.clinics count]) {
    return nil;
  }
  Clinic* c = [self.clinics objectAtIndex:row];
  cell.textLabel.text = c.village.name;
  return cell;
}

@end
