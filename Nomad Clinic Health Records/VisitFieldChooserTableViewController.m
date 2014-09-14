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

@end

@implementation VisitFieldChooserTableViewController

- (instancetype) initWithVisit:(VisitNotesComplex*) v {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    self.visitNotes = v;
    [self.tableView registerClass:[PatientVisitTableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.visitModelDisplayMetadata = VisitFieldMetadata.visitFieldMetadata;
  }
  return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style {
  return [self initWithVisit:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
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
  if ([self.visitNotes valueForKey:fieldName] != nil) {
    [self.visitNotes setValue:nil forKey:fieldName];
  } else {
    NSObject* defaultValue = [fieldMetadata objectForKey:@"defaultValue"];
    [self.visitNotes setValue:defaultValue forKey:fieldName];
  }
  [[BaseStore sharedStoreForEntity:@"VisitNotesComplex"] saveChanges];
  [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
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
