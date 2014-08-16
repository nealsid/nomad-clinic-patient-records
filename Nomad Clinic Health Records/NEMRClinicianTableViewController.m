//
//  NEMRClinicianTableViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/28/14.
//  Copyright (c) 2014 Neal Sidhwaney. All rights reserved.
//

#import "NEMRClinicianTableViewController.h"
#import "ClinicianViewController.h"
#import "Clinician.h"
#import "ClinicianStore.h"

@interface NEMRClinicianTableViewController ()

@property (nonatomic, strong) IBOutlet UIView* headerView;
@property (nonatomic, retain) UIFont* itemFont;
@property (nonatomic, retain) ClinicianStore* clinicianStore;
@property (nonatomic, retain) NSArray* clinicians;

@end

@implementation NEMRClinicianTableViewController

- (instancetype) init {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.itemFont = [UIFont systemFontOfSize:20];
    self.clinicianStore = [ClinicianStore sharedClinicianStore];
    self.clinicians = [self.clinicianStore clinicians];
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
  UIView* headerView = self.headerView;
  [self.tableView setTableHeaderView:headerView];
}

- (BOOL) isLastRow:(NSInteger)rowNumber {
  return rowNumber == ([self.clinicians count]);
}

- (IBAction)toggleEditing:(id)sender {
  if (self.isEditing) {
    [sender setTitle:@"Edit" forState:UIControlStateNormal];
    [self setEditing:NO animated:YES];
  } else {
    [sender setTitle:@"Done" forState:UIControlStateNormal];
    [self setEditing:YES animated:YES];
  }
}

- (IBAction)addNewItem:(id)sender {
  ClinicianViewController* cvc =
    [[ClinicianViewController alloc] initWithNibName:nil
                                                  bundle:nil
                                            andClinician:nil
                                            withDelegate:self];

  [self presentViewController:cvc animated:YES completion:nil];
}

#pragma mark - Table view data source

- (UIView*) headerView {
  if (!_headerView) {
    [[NSBundle mainBundle] loadNibNamed:@"ClinicianTableViewHeader"
                                  owner:self
                                options:nil];
  }
  return _headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  NSLog(@"Selecting row at: %lu", (long)row);
  Clinician* c = [self.clinicians objectAtIndex:row];
  ClinicianViewController* cvc =
      [[ClinicianViewController alloc] initWithNibName:nil
                                                    bundle:nil
                                              andClinician:c
                                              withDelegate:self];

  [self presentViewController:cvc animated:YES completion:nil];
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

- (BOOL)            tableView:(UITableView *)tableView
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  if ([self isLastRow:row]) {
    return NO;
  }
  return YES;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
  return [self.clinicians count] + 1;
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
      [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:@"UITableViewCell"];
  [cell setBackgroundColor:nil];
  if ([self isLastRow:row]) {
    cell.textLabel.text = @"No more clinicians";
    return cell;
  }
  if (row > [self.clinicians count]) {
    return nil;
  }
  Clinician* c = [self.clinicians objectAtIndex:row];
  cell.textLabel.text = c.name;
  [cell.textLabel setFont:self.itemFont];
  return cell;
}

- (void) clinicianViewControllerSave:(ClinicianViewController*)clinicianViewController
                           clinician:(Clinician*)c {
  [self dismissViewControllerAnimated:YES completion:nil];
  self.clinicians = [self.clinicianStore clinicians];
  [self.tableView reloadData];
}

- (void) clinicianViewControllerCancel:(ClinicianViewController*)clinicianViewController {
  [self dismissViewControllerAnimated:YES completion:nil];

}

@end
