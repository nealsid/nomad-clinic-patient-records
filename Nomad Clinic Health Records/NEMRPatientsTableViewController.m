//
//  NEMRPatientsTableViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "NEMRPatientsTableViewController.h"
#import "NEMRPatientViewController.h"
#import "FlexDate+ToString.h"
#import "Patient.h"
#import "PatientStore.h"

@interface NEMRPatientsTableViewController ()

@property (nonatomic, strong) IBOutlet UIView* headerView;
@property (nonatomic, retain) UIFont* itemFont;
@property (nonatomic, retain) PatientStore* patientStore;
@property (nonatomic, retain) NSArray* patients;

/**
 * Returns true if the rowNumber represents the last row in the table view.
 * Note that this is 1 more than the number of elements in Patients because
 * we provide a row that indicates "No more patients" at the bottom, so this
 * test is frequently done to determine if the user can perform some action on
 * a row.
 *
 * @param rowNumber the Row Number to test whether is last.
 * @returns YES if it's the last row in the table view, NO if not.
 */
- (BOOL) isLastRow:(NSInteger)rowNumber;

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

- (void)viewDidLoad
{
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
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.patients = [self.patientStore patients];
  [self.tableView reloadData];
}

- (BOOL) isLastRow:(NSInteger)rowNumber {
  return rowNumber == [self.patients count];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  NSLog(@"Selecting row at: %lu", (long)row);
  Patient* p = [self.patients objectAtIndex:row];
  NEMRPatientViewController* pvc =
  [[NEMRPatientViewController alloc] initWithNibName:nil
                                              bundle:nil
                                          andPatient:p];

  [self.navigationController pushViewController:pvc animated:YES];
}

- (BOOL)    tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (BOOL)                     tableView:(UITableView *)tableView
shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  return ![self isLastRow: [indexPath row]];
}

- (BOOL)              tableView:(UITableView *)tableView
shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
  return ![self isLastRow: [indexPath row]];
}

- (BOOL)    tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return ![self isLastRow:[indexPath row]];
}

- (CGFloat)    tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
  return 5;
}

- (UIView*)    tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
  UIView* view = [[UIView alloc] init];
  view.backgroundColor = [UIColor whiteColor];
  return view;
}

- (CGFloat)    tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
  return 0;
}

- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {

  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Patient* p = [self.patients objectAtIndex:[indexPath row]];
    [[PatientStore sharedPatientStore] removePatient:p];
    self.patients = [self.patientStore patients];
    [tableView deleteRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
  }
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
  // We return the number of rows, plus 1 extra
  // row for the "No more patients" row.
  return [self.patients count] + 1;
}

- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  if (![self isLastRow:row]) {
    return 60;
  }
  return 44;
}

- (void) tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self isLastRow:[indexPath row]]) {
    return;
  }
  if ([indexPath row] % 2 == 0) {
    cell.backgroundColor = [UIColor colorWithRed:0xda/255.0 green:0xe5/255.0 blue:0xf4/255.0 alpha:1.0];
  }
  cell.layer.cornerRadius = 20;
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

- (BOOL)            tableView:(UITableView *)tableView
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  return ![self isLastRow:row];
}

- (IBAction) addNewItem: (id) sender {
  NEMRPatientViewController* pvc =
    [[NEMRPatientViewController alloc] initWithNibName:nil
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
