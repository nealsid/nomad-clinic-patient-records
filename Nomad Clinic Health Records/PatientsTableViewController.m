//
//  NEMRPatientsTableViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "PatientsTableViewController.h"

#import "BaseStore.h"
#import "Clinic.h"
#import "PatientViewController.h"
#import "FlexDate+ToString.h"
#import "Patient.h"
#import "Patient+Gender.h"
#import "PatientAddEditViewController.h"
#import "TableViewController.h"
#import "Village.h"

@interface PatientsTableViewController ()

@property (nonatomic, retain) UIFont* itemFont;
@property (nonatomic, retain) BaseStore* patientStore;
@property (nonatomic, retain) NSArray* patients;
@property (nonatomic, retain) Clinic* clinic;

@end

@implementation PatientsTableViewController

- (instancetype) init {
  return [self initForClinic:nil];
}

- (instancetype) initForClinic:(Clinic*) c {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.itemFont = [UIFont systemFontOfSize:20];
    self.numberOfRows = [self.patients count];
    self.clinic = c;
    [self refreshPatientsFromStore];
    NSLog(@"%lu patients", (long)self.patients.count);
    if (self.clinic) {
      self.hidesBottomBarWhenPushed = YES;
      self.title = self.clinic.village.name;
    } else {
      self.title = @"All patients";
    }
  }
  return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style {
  return [self initForClinic:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"UITableViewCell"];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.navigationController.navigationBar.titleTextAttributes =
  [NSDictionary dictionaryWithObjects:@[[UIColor blackColor],
                                        [UIFont boldSystemFontOfSize:24]]
                              forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
  UIBarButtonItem* newPatientButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                    target:self
                                                                                    action:@selector(addNewItem:)];
  self.navigationItem.rightBarButtonItem = newPatientButton;
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self refreshPatientsFromStore];
  [self.tableView reloadData];
}

#pragma mark - Table view data source

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  Patient* p = [self.patients objectAtIndex:row];

  NSLog(@"%@", p);
  PatientViewController* pvc = [[PatientViewController alloc] initWithNibName:nil bundle:nil andPatient:p];

  [self.navigationController pushViewController:pvc animated:YES];
}

- (void) refreshPatientsFromStore {
  if (!self.patientStore) {
    self.patientStore = [BaseStore sharedStoreForEntity:@"Patient"];
  }
  self.patients = [self.patientStore patientsForClinic:self.clinic];
  self.numberOfRows = [self.patients count];
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {

  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Patient* p = [self.patients objectAtIndex:[indexPath row]];
    [self.patientStore removeEntity:p];
    [self refreshPatientsFromStore];

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
  if ([self isLastRow:row]) {
    cell.textLabel.text = @"No more patients";
    return cell;
  }
  [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  if (row > [self.patients count]) {
    return nil;
  }
  Patient* p = [self.patients objectAtIndex:row];
  cell.textLabel.text = p.name;
  [cell.textLabel setFont:self.itemFont];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
  if ([p isFemale]) {
    cell.imageView.image = [UIImage imageNamed:@"female-patient"];
  } else if([p isMale]) {
    cell.imageView.image = [UIImage imageNamed:@"male-patient"];
  }

  cell.detailTextLabel.text = [NSString stringWithFormat:@"Born: %@",
                               [p.dob toString]];
  cell.detailTextLabel.textColor = [UIColor grayColor];
  return cell;
}

- (void) addNewItem: (id) sender {
  PatientAddEditViewController* pvc =
    [[PatientAddEditViewController alloc] initForNewPatientInVillage:self.clinic.village atClinic:self.clinic];
  [self.navigationController pushViewController:pvc animated:YES];
}

- (IBAction) toggleEditing: (id) sender {
  if (self.isEditing) {
    [sender setTitle:@"Edit" forState:UIControlStateNormal];
    [self setEditing:NO animated:YES];
  } else {
    [sender setTitle:@"Done" forState:UIControlStateNormal];
    [self setEditing:YES animated:YES];
  }
}



@end
