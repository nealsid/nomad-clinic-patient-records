//
//  NEMRPatientsTableViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/20/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "NEMRPatientsTableViewController.h"
#import "NEMRPatientViewController.h"
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
    self.patients = [self.patientStore patients];
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
//  UIView* headerView = self.headerView;
//  [self.tableView setTableHeaderView:headerView];
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.navigationController setTitle:@"Patient"];
  UIBarButtonItem* newPatientButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                    target:self
                                                                                    action:@selector(addNewItem:)];
  [self.navigationItem setRightBarButtonItem:newPatientButton];
}

- (UIView*) headerView {
  if (!_headerView) {
    [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                  owner:self
                                options:nil];
  }
  return _headerView;
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
                                          andPatient:p
                                        withDelegate:self];

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
  return 0;
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

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  UITableViewCell* cell =
      [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                             reuseIdentifier:@"UITableViewCell"];
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
  cell.detailTextLabel.text = @"1980/09/02";
  NSString* imagePath;
  if ([p.gender isEqualToNumber:[NSNumber numberWithInt:0]]) {
    imagePath = [[NSBundle mainBundle] pathForResource:@"female-patient"
                                                          ofType:@"png"];
  } else if ([p.gender isEqualToNumber:[NSNumber numberWithInt:1]]) {
    imagePath = [[NSBundle mainBundle] pathForResource:@"male-patient"
                                                          ofType:@"png"];
  }
  UIImage* femaleImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
  [cell.imageView setImage:femaleImage];
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
                                            andPatient:nil
                                          withDelegate:self];

  [self presentViewController:pvc animated:YES completion:nil];
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

- (void) patientViewControllerSave:(NEMRPatientViewController*)patientViewController
                           patient:(Patient*)p {
  [self dismissViewControllerAnimated:YES
                           completion:nil];
  self.patients = [self.patientStore patients];
  [self.tableView reloadData];
}

- (void) patientViewControllerCancel:(NEMRPatientViewController*)patientViewController {
  [self dismissViewControllerAnimated:YES
                           completion:nil];
}

@end
