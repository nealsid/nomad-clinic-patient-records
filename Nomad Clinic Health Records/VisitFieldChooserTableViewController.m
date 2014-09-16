//
//  VisitFieldChooserTableViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/13/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "VisitFieldChooserTableViewController.h"

#import "BaseStore.h"
#import "PatientViewController+TableView.h"
#import "VisitFieldMetadata.h"
#import "VisitNotesComplex.h"

@interface VisitFieldChooserTableViewController ()

@property (weak, nonatomic) NSArray* visitModelDisplayMetadata;
@property (weak, nonatomic) VisitNotesComplex* visitNotes;

@property (strong, nonatomic) NSMutableSet* fieldsToRemove;
@property (strong, nonatomic) NSMutableSet* fieldsToAdd;

@end

@implementation VisitFieldChooserTableViewController

- (instancetype) initWithVisit:(VisitNotesComplex*) v {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    self.visitNotes = v;
    [self.tableView registerClass:[PatientVisitTableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.visitModelDisplayMetadata = VisitFieldMetadata.visitFieldMetadata;
    self.fieldsToAdd = [NSMutableSet set];
    self.fieldsToRemove = [NSMutableSet set];
  }
  return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style {
  return [self initWithVisit:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                              target:self
                                                                              action:@selector(saveChanges:)];
  self.navigationItem.rightBarButtonItem = editButton;
}

- (void) saveChanges:(id)sender {

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return self.visitModelDisplayMetadata.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  NSDictionary* fieldMetadata = self.visitModelDisplayMetadata[row];
  NSString* fieldName = [fieldMetadata objectForKey:@"fieldName"];

  NSNumber* rowNumber = [NSNumber numberWithInt:row];
  if (self.fieldsToAdd member:rowNumber) {

  }

  if ([self.visitNotes valueForKey:fieldName] != nil) {
    [self.fieldsToRemove addObject:[NSNumber numberWithInteger:row]];
    [self.visitNotes setValue:nil forKey:fieldName];
  } else {
    [self.fieldsToAdd addObject:[NSNumber numberWithInteger:row]];
  }

    NSObject* defaultValue = [fieldMetadata objectForKey:@"defaultValue"];
    [self.visitNotes setValue:defaultValue forKey:fieldName];
    // Special case blood pressure (lots of these :-( )
    if ([fieldName isEqualToString:@"bp_systolic"]) {
      [self.visitNotes setValue:defaultValue forKey:@"bp_diastolic"];
    }
  }
  [[BaseStore sharedStoreForEntity:@"VisitNotesComplex"] saveChanges];
  [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                          forIndexPath:indexPath];
  NSInteger row = [indexPath row];
  NSDictionary* fieldMetadata = self.visitModelDisplayMetadata[row];
  cell.textLabel.text = [fieldMetadata objectForKey:@"prettyName"];
  if ([self.visitNotes valueForKey:[fieldMetadata objectForKey:@"fieldName"]] != nil) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  return cell;
}

@end
