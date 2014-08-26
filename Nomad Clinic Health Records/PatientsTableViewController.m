//
//  NEMRPatientsTableViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "PatientsTableViewController.h"

#import "Clinic.h"
#import "PatientViewController.h"
#import "FlexDate+ToString.h"
#import "Patient.h"
#import "Patient+Gender.h"
#import "PatientStore.h"
#import "TableViewController.h"
#import "Village.h"

@interface PatientsTableViewController ()

@property (nonatomic, strong) IBOutlet UIView* headerView;
@property (nonatomic, retain) UIFont* itemFont;
@property (nonatomic, retain) PatientStore* patientStore;
@property (nonatomic, retain) NSArray* patients;
@property (nonatomic, retain) Clinic* clinic;

@end

@implementation PatientsTableViewController

- (instancetype) init {
  return [self initForClinic:nil];
}

- (instancetype) initForClinic:(Clinic*)c {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.itemFont = [UIFont systemFontOfSize:20];
    self.numberOfRows = [self.patients count];
    self.clinic = c;
    [self refreshPatientsFromStore];
    NSLog(@"%lu patients", (long)self.patients.count);
    if (self.clinic) {
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
  [NSDictionary dictionaryWithObjects:@[[UIColor darkGrayColor], [UIFont fontWithName:@"MarkerFelt-Thin" size:24.0]] forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
  UIBarButtonItem* newPatientButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                    target:self
                                                                                    action:@selector(addNewItem:)];
  self.navigationItem.rightBarButtonItem = newPatientButton;
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

#pragma mark - Table view data source

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  Patient* p = [self.patients objectAtIndex:row];

  NSLog(@"%@", p);
  PatientViewController* pvc =
  [[PatientViewController alloc] initWithNibName:nil
                                              bundle:nil
                                          andPatient:p];

  [self.navigationController pushViewController:pvc animated:YES];
}

- (void) refreshPatientsFromStore {
  if (!self.patientStore) {
    self.patientStore = [PatientStore sharedPatientStore];
  }
  self.patients = [self.patientStore patientsForClinic:self.clinic];
  self.numberOfRows = [self.patients count];
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {

  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Patient* p = [self.patients objectAtIndex:[indexPath row]];
    [self.patientStore removePatient:p];
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
  switch ([p.gender intValue]) {
    case Female:
      gender = @"Female";
      break;
    case Male:
      gender = @"Male";
      break;
    case Other:
    default:
      gender = @"Other";
      break;
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
