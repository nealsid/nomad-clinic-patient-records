//
//  PatientVisitViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 7/29/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PatientVisitViewController.h"

#import "Clinician.h"
#import "Patient.h"
#import "PatientVisit.h"
#import "PatientVisitNotes.h"
#import "PatientVisitNoteViewController.h"
#import "PatientVisitStore.h"

@interface PatientVisitViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) PatientVisit* patientVisit;
@property (strong, nonatomic) NSArray* notes;
@property (nonatomic, retain) UIFont* itemFont;

@property (weak, nonatomic) IBOutlet UILabel *patientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *clinicianNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *noteTableView;

@end

@implementation PatientVisitViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.patientNameLabel.text = self.patientVisit.patient.name;
  self.clinicianNameLabel.text = [[self.patientVisit.clinician anyObject] name];
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
                    patientVisit:(PatientVisit*)pv {
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self) {
    self.patientVisit = pv;
    [self.noteTableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:@"UITableViewCell"];
    self.itemFont = [UIFont systemFontOfSize:20];
    PatientVisitStore* pvstore = [PatientVisitStore sharedPatientVisitStore];
    self.notes = [pvstore notesForPatientVisit:self.patientVisit];
  }
  return self;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.notes count] + 1;
}

- (BOOL) isLastRow:(NSInteger)rowNumber {
  return rowNumber == ([self.notes count]);
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
  return @"Notes";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (BOOL)            tableView:(UITableView *)tableView
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  if ([self isLastRow:row]) {
    return NO;
  }
  return YES;
}

- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  if (![self isLastRow:row]) {
    return 60;
  }
  return 44;
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

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  UITableViewCell* cell =
  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                         reuseIdentifier:@"UITableViewCell"];
  [cell setBackgroundColor:nil];
  if ([self isLastRow:row]) {
    cell.textLabel.text = @"No more notes";
    return cell;
  }
  [cell.textLabel setFont:self.itemFont];
  PatientVisitNotes* oneNote = [self.notes objectAtIndex:row];

  NSString* cellText = [NSString stringWithFormat:@"%@/%@, %@, %@, %@",
                        oneNote.bp_systolic,
                        oneNote.bp_diastolic,
                        oneNote.breathing_rate,
                        oneNote.pulse,
                        oneNote.temp_fahrenheit];
  cell.textLabel.text = cellText;
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                               oneNote.note_date];
  return cell;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  PatientVisitNoteViewController* pvnvc = [[PatientVisitNoteViewController alloc]
                                           initWithNibName:nil
                                           bundle:nil
                                           patientVisitNote:[self.notes objectAtIndex:row]];
  [self.navigationController pushViewController:pvnvc animated:YES];
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil {
  [NSException raise:@"Unsupported initializer"
              format:@"Reason: You must use the designated initializer for this class"];
  return nil;
}

@end
