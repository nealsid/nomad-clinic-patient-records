//
//  VisitFieldChooserTableViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/13/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "VisitFieldChooserTableViewController.h"

#import "PatientViewController+TableView.h"
#import "VisitNotesComplex.h"

@interface VisitFieldChooserTableViewController ()

@property (strong, nonatomic) NSArray* visitModelDisplayMetadata;
@property (weak, nonatomic) VisitNotesComplex* visitNotes;

@end

@implementation VisitFieldChooserTableViewController

- (instancetype) initWithVisit:(VisitNotesComplex*) v {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    self.visitNotes = v;
    [self.tableView registerClass:[PatientVisitTableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.visitModelDisplayMetadata = @[@{@"fieldName":@"healthy",
                                         @"prettyName":@"Is Healthy?",
                                         @"defaultValue":[NSNumber numberWithBool:NO]},

                                          @{@"fieldName":@"bp_systolic",
                                            @"prettyName":@"Blood pressure",
                                            @"defaultValue":[NSNumber numberWithInt:0]},

                                          @{@"fieldName":@"breathing_rate",
                                            @"prettyName":@"Breathing rate",
                                            @"defaultValue":[NSNumber numberWithInt:0]},

                                          @{@"fieldName":@"pulse",
                                            @"prettyName":@"Pulse",
                                            @"defaultValue":[NSNumber numberWithInt:0]},

                                          @{@"fieldName":@"temp_fahrenheit",
                                            @"prettyName":@"Temp (℉)",
                                            @"defaultValue":[NSNumber numberWithInt:0]},

                                          @{@"fieldName":@"weight",
                                            @"prettyName":@"Weight",
                                            @"defaultValue":[NSNumber numberWithInt:0]},

                                          @{@"fieldName":@"weight_class",
                                            @"prettyName":@"Weight class",
                                            @"defaultValue":[NSNumber numberWithInt:2]},

                                          @{@"fieldName":@"subjective",
                                            @"prettyName":@"Subjective",
                                            @"defaultValue":@""},

                                          @{@"fieldName":@"objective",
                                            @"prettyName":@"Objective",
                                            @"defaultValue":@""},

                                          @{@"fieldName":@"assessment",
                                            @"prettyName":@"Assessment",
                                            @"defaultValue":@""},

                                          @{@"fieldName":@"plan",
                                            @"prettyName":@"Plan",
                                            @"defaultValue":@""},

                                          @{@"fieldName":@"note",
                                            @"prettyName":@"Note",
                                            @"defaultValue":@""}];

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
