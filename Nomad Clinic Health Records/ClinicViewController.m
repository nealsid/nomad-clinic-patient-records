//
//  ClinicViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/22/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "Clinic.h"
#import "ClinicViewController.h"

#import "BaseStore.h"
#import "Clinic.h"
#import "ClinicAddEditViewController.h"
#import "PatientsTableViewController.h"
#import "Village.h"
#import "Utils.h"

@interface ClinicViewController ()

@property (nonatomic, retain) BaseStore* clinicStore;
@property (nonatomic, retain) NSArray* clinics;

@property (nonatomic, retain) UIFont* itemFont;

@property (strong, nonatomic) UIBarButtonItem* editButton;
@end

@implementation ClinicViewController

- (instancetype) init {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    NSLog(@"%lu patients", (long)[[[BaseStore sharedStoreForEntity:@"Patient"] entities] count]);
    self.clinicStore = [BaseStore sharedStoreForEntity:@"Clinic"];
    [self refetchDataForTableView];
    self.title = @"Clinics";
    self.itemFont = [UIFont fontWithName:@"American Typewriter" size:32];
  }
  return self;
}

- (void) refetchDataForTableView {
  self.clinics = [self.clinicStore entitiesWithSortKey:@"village.name,clinic_date" ascending:YES];
  self.numberOfRows = self.clinics.count;
}

- (instancetype) initWithStyle:(UITableViewStyle)style {
  return [self init];
}

- (void) viewWillAppear:(BOOL)animated {
  [self refetchDataForTableView];
  [self.tableView reloadData];
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
  UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
  self.navigationItem.leftBarButtonItem = editButton;
  self.tableView.allowsSelectionDuringEditing = YES;
}

- (void) addNewClinic:(id) sender {
  ClinicAddEditViewController *cvc = [[ClinicAddEditViewController alloc] initWithNibName:nil bundle:nil];
  [self.navigationController pushViewController:cvc animated:YES];
}

- (void) toggleEditing {
  BOOL editing = self.tableView.isEditing;
  if (editing) {
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
  } else {
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(edit:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
  }
  [self.tableView setEditing:![self.tableView isEditing]];
}
- (void) edit:(id) sender {
  [self toggleEditing];
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  Clinic* c = [self.clinics objectAtIndex:row];

  NSLog(@"Clinic selected: %@", c);

  if (self.tableView.editing) {
    ClinicAddEditViewController *cvc = [[ClinicAddEditViewController alloc] initWithClinic:c];
    [self.navigationController pushViewController:cvc animated:YES];
    [self toggleEditing];
  } else {
    PatientsTableViewController* pvc =
    [[PatientsTableViewController alloc] initForClinic:c];

    [self.navigationController pushViewController:pvc animated:YES];
  }
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {

  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Clinic* c = [self.clinics objectAtIndex:[indexPath row]];
    [self.clinicStore removeEntity:c];
    [self refetchDataForTableView];

    [tableView deleteRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    [tableView reloadData];
  }
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
  cell.detailTextLabel.text = [Utils dateToMediumFormat:c.clinic_date];
  return cell;
}


@end
