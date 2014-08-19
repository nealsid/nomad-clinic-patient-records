//
//  NEMRPatientsTableViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "NEMRPatientsTableViewController.h"
#import "PatientViewController.h"
#import "FlexDate+ToString.h"
#import "Patient.h"
#import "PatientStore.h"
#import "TableViewController.h"

@interface NEMRPatientsTableViewController ()

@property (nonatomic, strong) IBOutlet UIView* headerView;
@property (nonatomic, retain) UIFont* itemFont;
@property (nonatomic, retain) PatientStore* patientStore;
@property (nonatomic, retain) NSArray* patients;

@end

@implementation NEMRPatientsTableViewController

- (instancetype) init {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.itemFont = [UIFont systemFontOfSize:20];
    self.patientStore = [PatientStore sharedPatientStore];
  }
  return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style {
  return [self init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"UITableViewCell"];
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.title = @"Patients";
  self.navigationController.navigationBar.titleTextAttributes =
  [NSDictionary dictionaryWithObjects:@[[UIColor darkGrayColor], [UIFont fontWithName:@"MarkerFelt-Thin" size:24.0]] forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
  UIBarButtonItem* newPatientButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                    target:self
                                                                                    action:@selector(addNewItem:)];
  [self.navigationItem setRightBarButtonItem:newPatientButton];
  self.patients = [self.patientStore patients];
  self.numberOfRows = [self.patients count];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.patients = [self.patientStore patients];
  self.numberOfRows = [self.patients count];
  [self.tableView reloadData];
}

#pragma mark - Table view data source

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  Patient* p = [self.patients objectAtIndex:row];
  PatientViewController* pvc =
  [[PatientViewController alloc] initWithNibName:nil
                                              bundle:nil
                                          andPatient:p];

  [self.navigationController pushViewController:pvc animated:YES];
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {

  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Patient* p = [self.patients objectAtIndex:[indexPath row]];
    [self.patientStore removePatient:p];
    self.patients = [self.patientStore patients];
    self.numberOfRows = [self.patients count];

    [tableView deleteRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
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
  [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
  if (row > [self.patients count]) {
    return nil;
  }
  Patient* p = [self.patients objectAtIndex:row];
  cell.textLabel.text = p.name;
  [cell.textLabel setFont:self.itemFont];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
  NSString* gender = @"";
  if ([p.gender isEqualToNumber:[NSNumber numberWithInt:0]]) {
    gender = @"Female";
  } else if ([p.gender isEqualToNumber:[NSNumber numberWithInt:1]]) {
    gender = @"Male";
  }
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, Born: %@",
                               gender, [p.dob toString]];
  cell.detailTextLabel.textColor = [UIColor grayColor];
  return cell;
}

- (IBAction) addNewItem: (id) sender {
  PatientViewController* pvc =
    [[PatientViewController alloc] initWithNibName:nil
                                                bundle:nil
                                            andPatient:nil];
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
